class GroupsController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_group_and_check_permission , only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end

  def new
    @group = Group.new
  end

  def show
    @group = Group.find(params[:id])
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: '话题已被你更新！是的！你更新了它！更新了！！'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, alert: '话题被你删除了！没有了！没有了！！'
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本话题组成功！当当了琅铛～铛铛！！"
    else
      flash[:warning] = "你已经是本话题组成员了！都是了！还加什么加！！"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本话题组！退出了！走了就别回来！！"
    else
      flash[:warning] = "你不是本话题组成员，怎么退出？XD"
    end

    redirect_to group_path(@group)
  end

  private

  def find_group_and_check_permission
    @group = Group.find(params[:id])
    if current_user != @group.user
      redirect_to root_path, alert: "你无权这样做！无权！！臭不要脸！！"
    end
  end

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
