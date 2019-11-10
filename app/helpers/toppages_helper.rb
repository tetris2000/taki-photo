module ToppagesHelper
  def post_counts(prf)
    prf.posts.count
  end
end
