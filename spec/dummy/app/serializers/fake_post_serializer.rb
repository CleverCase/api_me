class HasManyRelation
  attr_reader :descriptor

  def initialize(descriptor)
    @descriptor = descriptor
  end

  def relation_class
    descriptor.class_name
  end

  def table_name
    relation_class.table_name
  end

  def name
    descriptor.name
  end

  def batch(object)
    inverse_name = descriptor.inverse_of || object.class.table_name

    BatchLoader.for(object.id).batch do |relation_ids, loader|
      relation_class.joins(inverse_name.to_sym)
        .where(id: relation_ids)
        .pluck("#{object.class.table_name}.id", "#{table_name}.id")
        .group_by { |set| set[0] }
        .each_pair do |key, value|
          loader.call(key, value.map { |set| set[1] })
        end
    end
  end
end

class HasManyDescriptor
  attr_reader :name, :table_name, :inverse_of, :class_name

  def initialize(name, table_name: nil, inverse_of: nil, class_name: nil)
    @name = name

    @class_name = class_name || name.to_s.classify.constantize
    @inverse_of = inverse_of
  end
end

class SerializerMeta
  def initialize
    @has_many_relationships = []
    @attributes = []
  end

  def add_has_many(descriptor)
    @has_many_relationships.push(HasManyRelation.new(descriptor))
  end

  def add_attribute(name)
    @attributes.push(name)
  end

  def has_many_relations
    @has_many_relationships.each
  end

  def attributes
    @attributes.each
  end
end

class BaseSerializer
  attr_reader :object

  def self.serializer_meta
    @serializer_meta ||= SerializerMeta.new
  end

  def self.has_many(name, options = {})
    descriptor = HasManyDescriptor.new(name, options)
    serializer_meta.add_has_many(descriptor)
  end

  def self.attributes(*attrs)
    attrs.each { |attr| serializer_meta.add_attribute(attr) }
  end

  def initialize(object)
    @object = object
  end

  def batch_relations
    batch_has_many
  end

  def batch_has_many
    @lazy_has_many_relations = self.class.serializer_meta.has_many_relations.map do |relation|
      { relation.name => relation.batch(self.object) }
    end
  end

  def hash_has_many_relations
    @lazy_has_many_relations.reduce({}) { |relations_hash, lazy_hash|
      relations_hash.merge!(lazy_hash)
    }
  end

  def hash_attributes
    self.class.serializer_meta.attributes.reduce({}) do |hash, attr|
      if self.respond_to?(attr)
        hash.merge!(attr => self.send(attr))
      else
        hash.merge!(attr => object.send(attr))
      end
    end
  end

  def serializable_hash
    hash_has_many_relations.merge!(hash_attributes)
  end

  def as_json
    serializable_hash.as_json
  end
end

class FakePostSerializer < BaseSerializer
  has_many :tags

  attributes :id, :name
end
