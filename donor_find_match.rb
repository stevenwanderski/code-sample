class DonorFindMatch < ApplicationService
  def initialize(params:)
    @params = params
  end

  def call
    find_by_fuzzy_match
  end

  private

  def find_by_fuzzy_match
    Donor
      .where(nonprofit_id: param_nonprofit_id)
      .where(fuzzy_sql, param_first_name, param_last_name, param_address_1)
      .first
  end

  def fuzzy_sql
    %{
      LOWER(TRIM(COALESCE(first_name, ''))) = ?
      AND LOWER(TRIM(COALESCE(last_name, ''))) = ?
      AND LOWER(TRIM(COALESCE(address_1, ''))) = ?
    }
  end

  def param_address_1
    param_value(:address_1)
  end

  def param_first_name
    param_value(:first_name)
  end

  def param_last_name
    param_value(:last_name)
  end

  def param_nonprofit_id
    param_value(:nonprofit_id)
  end

  def param_value(key)
    return '' if @params[key].nil?

    @params[key].strip.downcase
  end
end
