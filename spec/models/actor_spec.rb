require 'spec_helper'

describe Actor do

  describe ".reset_all" do

    context "actor reset" do

      let(:actor_1) { Actor.new(in_play: true, place_id: 1) }
      let(:actor_2) { Actor.new(in_play: true, place_id: 2) }
      let(:actor_3) { Actor.new(in_play: true, place_id: 3) }

      before do
        Actor.stub(:all) { [actor_1, actor_2, actor_3] }
        Actor.stub(:grue) { actor_3 }
        Actor.any_instance.stub(:save) { true }
        Actor.any_instance.stub(:put_in_play) { true }
      end

      it "sets in_play to false" do
        Actor.reset_all
        expect(actor_1.in_play).to be_false
      end

      it "clears place_id" do
        Actor.reset_all
        expect(actor_1.place_id).to be_nil
      end

      it "saves" do
        expect(actor_1).to receive(:save)
        Actor.reset_all
      end

    end

  end

  describe "#brew" do

    let(:actor) { Actor.new }
    let(:beverage) { Beverage.new(name: "foo fizz") }

    before do
      Beverage.stub(:brew_random) { beverage }
    end

    it "adds a beverage to its inventory" do
      actor.brew
      expect(actor.beverages.first).to eq(beverage)
    end

  end

  describe "#perform_random_action" do

    let(:actor) { Actor.new }

    context "when random condition is not met" do

      it "returns false" do
        Alice::Util::Randomizer.stub(:one_chance_in) { false }
        expect(actor.perform_random_action).to be_false
      end

    end

    context "when random condition is met" do

      before do
        Actor::ACTIONS.stub(:sample) { :to_s }
      end

      it "performs a random action" do
        Alice::Util::Randomizer.stub(:one_chance_in) { true }
        expect(actor.perform_random_action).to be_true
      end

    end

  end

  describe "#proper name" do

    let(:actor) { Actor.new }

    it "returns a capitalized version of its name" do
      actor.name = "first of the fallen"
      expect(actor.proper_name).to eq("First Of The Fallen")
    end

  end

  describe "#reset_description" do

    let(:actor) { Actor.new(description: "Very tall.") }

    it "clears and sets a description" do
      actor.reset_description
      expect(actor.description).not_to eq("Very tall.")
    end

  end

end