class Api::V1::FailsController < ApplicationController # rubocop:disable ClassAndModuleChildren
  include ApiMe

  before_action :fail

  private

  def fail
    render json: { status: 'failed' }, status: 404
  end
end
