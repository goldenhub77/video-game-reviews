class AdminsController < ApplicationController
  before_action :load_objects, only: [:index]
  include ApplicationHelper
  def index
    if get_admin_params[:review_search]
      @all_reviews = Review.search(get_admin_params[:review_search])
      load_review_html
      if @all_reviews.empty? or @js_reviews.empty?
        @review_notice = "No reviews matching #{get_admin_params[:review_search]}"
      end
    end
    if get_admin_params[:video_game_search]
      @all_video_games = VideoGame.search(get_admin_params[:video_game_search])
      load_video_game_html
      if @all_video_games.empty? or @js_video_games.empty?
        @game_notice = "No video games matching #{get_admin_params[:video_game_search]}"
      end
    end
    if get_admin_params[:user_search]
      @all_users = User.search(get_admin_params[:user_search])
      load_user_html
      if @all_users.empty? or @js_users.empty?
        @user_notice = "No users matching #{get_admin_params[:user_search]}"
      end
    end

    respond_to do |response|
      response.js { render json: {
          videoGames: { objects: @js_video_games, notice: @game_notice },
          users: { objects: @js_users, notice: @user_notice },
          reviews: { objects: @js_reviews, notice: @review_notice }
        }
      }
      response.html { render :index }
    end
  end


  protected

  def load_objects
    @all_video_games = VideoGame.all
    @all_reviews = Review.all
    @all_users = User.all
    load_review_html
    load_video_game_html
    load_user_html
  end

  def load_video_game_html
    @js_video_games = []
    @all_video_games.each do |game|
      @js_video_games << { html: video_game_html(game) }
    end
  end

  def load_review_html
    @js_reviews = []
    @all_reviews.each do |review|
      @js_reviews << { html: review_html(review) }
    end
  end

  def load_user_html
    @js_users = []
    @all_users.each do |user|
      @js_users << { html: user_html(user)}
    end
  end

  def review_html(obj)
    "<tr>
      <td>#{object_date_joined(obj)}</td>
      <td>#{obj.title}</td>
      <td>#{obj.video_game.title}</td>
      <td>#{obj.user.full_name}</td>
      <td>#{obj.user.email}</td>
      <td><form class='button_to' method='get' action='/reviews/#{obj.id}'><input class='btn btn-secondary' type='submit' value='Show'></form></td>
      <td><form class='button_to' method='post' action='/reviews/#{obj.id}'><input type='hidden' name='_method' value='delete'><input data-confirm='Are you sure?' class='btn btn-danger' type='submit' value='Delete'><input type='hidden' name='authenticity_token' value=#{get_admin_params[:auth]}></form></td>
    </tr>"
  end

  def video_game_html(obj)
    "<tr>
      <td>#{object_date_joined(obj)}</td>
      <td>#{obj.title}</td>
      <td>#{obj.user.full_name}</td>
      <td>#{obj.user.email}</td>
      <td><form class='button_to' method='get' action='/video_games/#{obj.id}'><input class='btn btn-secondary' type='submit' value='Show'></form></td>
      <td><form class='button_to' method='post' action='/video_games/#{obj.id}'><input type='hidden' name='_method' value='delete'><input data-confirm='Are you sure?' class='btn btn-danger' type='submit' value='Delete'><input type='hidden' name='authenticity_token' value=#{get_admin_params[:auth]}></form></td>
    </tr>"
  end

  def user_html(obj)
    "<tr>
      <td>#{object_date_joined(obj)}</td>
      <td>#{obj.full_name}</td>
      <td>#{obj.email}</td>
      <td><a href='/admins/users/#{obj.id}/video_games'>#{obj.video_games.count}</a></td>
      <td><a href='/admins/users/#{obj.id}/reviews'>#{obj.reviews.count}</a></td>
      <td><form class='button_to' method='get' action='/admins/users/#{obj.id}'><input class='btn btn-secondary' type='submit' value='Show'></form></td>
      <td><form class='button_to' method='post' action='/admins/users/#{obj.id}'><input type='hidden' name='_method' value='delete'><input data-confirm='Are you sure?' class='btn btn-danger' type='submit' value='Delete'><input type='hidden' name='authenticity_token' value=#{get_admin_params[:auth]}></form></td>
    </tr>"
  end

  def get_admin_params
    params.permit(:review_search, :video_game_search, :user_search, :auth)
  end
end
