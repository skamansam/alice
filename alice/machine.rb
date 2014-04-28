class Alice::Machine

  include Mongoid::Document
  include Alice::Behavior::Searchable
  include Alice::Behavior::Placeable

  field :name
  field :description
  field :creation_class
  field :creation_params, type: Hash, default: {}

  validates_presence_of :name
  validates_uniqueness_of :name

  belongs_to :place
  has_many :actions

  attr_accessor :just_made

  def self.sweep
    all.map{|i| i.place = nil; i.save}
  end

  def describe
    self.description
  end

  def name_with_article
    Alice::Util::Sanitizer.process("#{Alice::Util::Randomizer.article} #{self.name}")
  end

  def use(trigger=nil)
    triggered = self.actions.triggered_by(trigger)
    triggered = self.actions.primary if triggered.empty?
    descriptions = triggered.map{|action| do_this(action)}.compact
    descriptions.map{|desc| desc.gsub!("<<machine_name>>", self.name_with_article)}
    descriptions.map{|desc| desc.gsub!("<<thing_name>>", self.just_made.name)} if self.just_made.present?
    descriptions.inject([]) {|descriptions, result| descriptions << result }.join(' ')
  end

  private

  def do_this(action)
    self.send(action.trigger_method) if action.trigger_method.present?
    action.description
  end

  def klass
    class_eval(self.creation_class)
  end

  def make
    thing = klass.new(creation_params)
    thing.name = thing.randomize_name
    thing.save
    self.just_made = thing
    Alice::Place.current.items << thing if thing.is_a? Alice::Item
    Alice::Place.current.beverages << thing if thing.is_a? Alice::Beverage
  end

end