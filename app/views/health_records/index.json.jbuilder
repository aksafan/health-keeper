# frozen_string_literal: true

json.array! @health_records, partial: 'health_records/health_record', as: :health_record
