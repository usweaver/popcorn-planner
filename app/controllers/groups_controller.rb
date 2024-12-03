class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      users = params[:group][:group_members].split("###")
      users.each do |user|
        Member.create!(user_id: user, group_id: @group.id)
      end
      redirect_to groups_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def search_users
    results = User.search(params[:query])
    users = results.map do|user|
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        username: user.username,
        url: url_for(user.profile_picture)
      }
    end

    respond_to do |format|
      format.json {
        render json: {response: users}
      }
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :group_picture)
  end
end
