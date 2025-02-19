# frozen_string_literal: true

class BaseService
  Result = Data.define(:success?, :error)

  def result(success, error: nil)
    Result.new(success, error)
  end

  private_constant :Result
end
