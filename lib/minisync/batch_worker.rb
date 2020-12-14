class Minisync::BatchWorker
  extend Dry::Initializer

  param  :model_class
  param  :target
  option :limit, default: proc { 1000 }
  option :scope, default: proc { model_class }
  option :builder, optinal: true

  attr_reader :models, :batch

  def call
    ids = find_ids
    revmap = nil
    model_class.transaction(isolation: :repeatable_read) do
      models = load_models(ids)
      batch  = serialize_batch(models)
      revmap = batch.map { |model, _proto| [model.id, model.revision_number] }
      push_batch(batch)
    end
    update(revmap)
  end


  def find_ids
    model_class.revision_class
               .unsynced(target)
               .order("random()")
               .limit(limit)
               .pluck(:source_id)
  end

  def load_models(ids)
    scope.preload_revision.where(id: ids)
  end

  def serialize_batch(models)
    models.map do |model|
      proto = serialize(model)
      break nil if proto.nil?
      [model, proto]
    end.compact
  end

  def serialize(_model)
    raise NotImplementedError
  end

  def push(batch)
    raise NotImplementedError
  end

  def update(revmap)
    Minisync::BatchUpdater.new(model_class.revision_class, target, revmap).call
  end
end
