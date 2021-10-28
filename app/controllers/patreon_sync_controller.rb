# frozen_string_literal: true

class ::Patreon::PatreonSyncController < ApplicationController

  def index
    if SiteSetting.patreon_sync_secret == request.headers['X-Patreon-Sync-Secret']
      user_id = params[:patreon_id]
      patreon_id = ActiveRecord::Base.connection.select_value("SELECT value FROM user_custom_fields WHERE name='patreon_id' AND user_id=#{user_id}")

      if patreon_id == nil
        render body: nil, status: 422
      else
        Jobs.enqueue(:sync_patron_groups, patreon_id: patreon_id.to_s)
        render body: nil, status: 200
      end
    else
      render body: nil, status: 403
    end
  end
end
