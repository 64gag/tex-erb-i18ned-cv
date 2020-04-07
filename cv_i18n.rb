require 'active_support/core_ext/string'
require 'date'
require 'logger'
require 'json'
require 'yaml'
require 'i18n'

class CvI18n
  def initialize(locale)
    I18n.load_path << Dir[File.expand_path("locales") + "/*.yml"]
    I18n.default_locale = locale

    hash_common = YAML::load_file(File.join(__dir__, "locales/common.yml"))['common']
    hash_locale = YAML::load_file(File.join(__dir__, "locales/#{locale}.yml"))[locale]
    build_hash_from_hashes(hash_common, hash_locale)
  end

  def build_hash_from_hashes(hash_common, hash_locale)
    @hash = hash_locale

    merge_common_hash_in(hash_common)
    expand_dates

    #puts JSON.pretty_generate(@hash)
    #puts JSON.pretty_generate(@hash['professional']['entries'])
  end

  def merge_common_hash_in(hash_common)
    hash_common['professional']['entries'].each do |entry|
      if entry['uid']
        target_uid = entry['uid']
        @hash['professional']['entries'].map! do |entry_member|
          if entry_member['uid'] == target_uid
            entry_member.merge(entry)
          else
            entry_member
          end
        end
      end
    end
  end

  def expand_dates
    @hash['professional']['entries'].map! do |entry|
      date_start = entry['date_start']
      date_end = entry['date_end']

      if date_start
        dates = [date_start, date_end]
        dates.reject! { |e| e.to_s.empty? }

        # If no date_end... add present
        if dates.size == 1
          dates << :present
        end

        dates.uniq!

        # Translate
        i18n_dates = dates.map do |date|
          maped_date = nil

          if date == :present
            maped_date = t('date.present')
          else
            date_time = date.to_time
            maped_date = I18n.l(date_time, format: :cv) if date_time
          end

          maped_date
        end

        # Join into a single string
        i18n_date = i18n_dates.join " -- "

        # Merge
        entry.merge ({ "date" => i18n_date })
      else
        entry
      end
    end
  end

  def translate(i18n_keys)
    keys = keys_from_i18n_keys(i18n_keys)

    get_value_at_keys(@hash, keys)
  end

  def keys_from_i18n_keys(i18n_keys)
    i18n_keys.split(".")
  end

  # I usually avoid recursive methods, but this project is dumb anyways! :)
  def get_value_at_keys(hash, keys)
    key = keys.shift

    if key
      get_value_at_keys(hash[key], keys)
    else
      hash
    end
  end

  alias_method :t, :translate
end
