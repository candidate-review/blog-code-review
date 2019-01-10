# Notes to candidate:
#
# 1. This is code submitted from a junior developer with less than a year of
#    experience. The ideal review will educate on terminology and concepts
#    while remaining understandable to someone without a lot of experience.
#
# 2. This file holds 95% of the material needed for the review. Scroll to the
#    bottom of the file for a couple of extras we've included. You can browse
#    for the other 5% in the source tree.
#
# 3. Trust that all the route descriptions match the routes.rb file.
#
# 4. We're looking for quality of code review, depth of understanding, and
#    quantity of items reviewed, in that order. Focus on quality and depth much
#    more than quantity. If you only get through part of the review, that's not
#    a big deal.
#
# 5. Everything below this line is fair game for the review. Have fun!
# ----------------------------------------------------------------------------

class BlogsController < ApplicationController
  ALL_BLOG_POSTS = BlogPost.all

  # GET /blogs/index
  def index
    @posts = ALL_BLOG_POSTS
  end

  # GET /blogs/get_posts
  def get_posts
    @posts = all_posts
  end

  # GET /blogs/get_pending_posts
  def get_pending_posts
    @posts = BlogPostFinder.find_pending_posts

    redirect_to :get_posts
  end

  # PUT /blogs/update_post/:id
  def update_post
    params.require(:post).permit(:id, :title, :body, :author)

    author = "#{current_user.first_name + ' ' + current_user.last_name}"

    BlogPostFinder.find_by_id(params[:id]).update(author: author)
  end

  # GET /blogs/get_current_users_blogposts
  def get_current_users_blogposts
    author = "#{current_user.first_name + ' ' + current_user.last_name}"

    @posts = BlogPost.find_by(author)
  end

  # POST /blogs/create_post
  def create_post
    post_params = params.require(:post).permit(:title, :body, :author)

    unless params['title'] == nil || params['title'] == '' || params['title'] == false
      title = params['title'].titilize
    end

    author = "#{current_user.first_name + ' ' + current_user.last_name}"

    blog_post = BlogPost.create(post_params)
    blog_post.update(author: author)
    blog_post.update(title: title)
  end

  # DELETE /blogs/delete
  def delete
    params.require(:post).permit(:id)

    unless params.type != 'comment'
      BlogPostFinder.find_post(params.id).destroy!

    else if params.type == 'comment'
      Comment.find(params.id).destroy!
    end
  end

  # PATCH /blogs/edit_posts
  def edit_posts
    params.permit!

    blog_post = BlogPost.find(params.posts.first.try('id'))

    current_post = blog_post

    current_post.update(params)
  end

  # GET /blogs/email_users_about_updated_posts
  def email_users_about_updated_posts
    User.all.each do |user|
      BlogPostFinder.updated_posts.each do |post|
        BlogMailer.deliver_later(user, post)
      end
    end

  end

  # POST /blogs/publish_post
  def publish_post
    params.require(:post).permit(:title, :body, :author)

    post = BlogPostFinder.find_by_title(:title)
    post.published = true
    post.save

  end

  private

  def all_posts
    BlogPost.where.not(author: nil)
  end

  class BlogPostFinder
    def self.find_post(id)
      return BlogPost.where(id).first
    end

    def self.find_post(id)
      return BlogPost.where(id).first
    end

    def self.find_pending_posts
      return BlogPost.find(status: 'pending')
    end

    def self.find_by_creator(creator)
      return BlogPost.where(author: creator)
    end

    def self.find_by_title(title)
      return BlogPost.where(title: title)
    end

    def self.updated_posts
      return BlogPost.where("updated_at < #{24.hours.ago}")
    end
  end

  # ----------------------------------------------------------------------------
  # Note to candidate: pretend that this mailer class works.
  # ----------------------------------------------------------------------------
  class BlogMailer < ActionMailer::Base
    def self.deliver_now(user, post)
      # pretend this works as a synchronous method
    end

    def self.deliver_later(user, post)
      # pretend this works as an asynchronous method
    end
  end

  # ----------------------------------------------------------------------------
  # Note to candidate: pretend that this method is OK.
  # ----------------------------------------------------------------------------
  def current_user
    User.new('john', 'doe')
  end
end
