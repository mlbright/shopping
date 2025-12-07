class HouseholdsController < ApplicationController
  before_action :set_household, only: [ :show, :edit, :update, :add_member, :remove_member ]
  before_action :verify_membership, only: [ :show, :edit, :update, :add_member, :remove_member ]

  def index
    @households = current_user.households.includes(:users, :shopping_lists)
  end

  def show
    @members = @household.users.includes(:household_memberships)
    @shopping_lists = @household.shopping_lists.order(updated_at: :desc)
  end

  def new
    @household = Household.new
  end

  def create
    @household = Household.new(household_params)
    @household.creator = current_user

    if @household.save
      redirect_to @household, notice: "Household created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @household.update(household_params)
      redirect_to @household, notice: "Household updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def add_member
    user = User.find_by(email: params[:email]&.downcase)

    if user.nil?
      redirect_to @household, alert: "User with that email not found."
      return
    end

    if @household.users.include?(user)
      redirect_to @household, alert: "User is already a member of this household."
      return
    end

    @household.household_memberships.create!(user: user, role: "member")
    redirect_to @household, notice: "Member added successfully!"
  end

  def remove_member
    user = User.find(params[:user_id])
    membership = @household.household_memberships.find_by(user: user)

    if membership
      if membership.role == "owner" && @household.household_memberships.where(role: "owner").count == 1
        redirect_to @household, alert: "Cannot remove the last owner."
        return
      end

      membership.destroy
      redirect_to @household, notice: "Member removed successfully!"
    else
      redirect_to @household, alert: "User is not a member of this household."
    end
  end

  private

  def set_household
    @household = Household.find(params[:id])
  end

  def verify_membership
    unless current_user.households.include?(@household)
      redirect_to households_path, alert: "You don't have access to that household."
    end
  end

  def household_params
    params.require(:household).permit(:name)
  end
end
