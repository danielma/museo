class SnapshotsController < ApplicationController
  def index
    @snapshots = [Snapshot.new(params[:one]), Snapshot.new(params[:two])]
  end

  class Snapshot
    attr_reader :name

    def initialize(name = "Snapshot")
      @name = name
    end
  end
end
