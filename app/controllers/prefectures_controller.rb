class PrefecturesController < ApplicationController
  def show
    @prefectures = Prefecture.all
    @prefecture = Prefecture.find(params[:id])
    counts(@prefecture.posts)
  end
end
