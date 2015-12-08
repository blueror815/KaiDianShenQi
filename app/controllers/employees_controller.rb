class EmployeesController < ApplicationController
  before_filter :authenticate_retailer!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = current_owner.employees
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(employee_params)
    @employee.user_type = 'Employee'
    @employee.owner = current_retailer
    if @employee.save
      Employee::PERMISSION_MODULES.each do |permission_module|
        if params[:permissions] && params[:permissions][permission_module]
          permission = Permission.new(permission_params(params[:permissions][permission_module]))
          permission.module_name = permission_module
          permission.retailer = @employee
          permission.save
        end
      end
      redirect_to employees_path
    else
      render action: :new
    end
  end
  
  def show
  end
  def edit
  end

  def update
    if @employee.update_attributes(employee_params)
      @employee.permissions.delete_all

      Employee::PERMISSION_MODULES.each do |permission_module|
        if params[:permissions] && params[:permissions][permission_module]
          permission = Permission.new(permission_params(params[:permissions][permission_module]))
          permission.module_name = permission_module
          permission.retailer = @employee
          permission.save
        end
      end
      redirect_to @employee
    else
      render action: :edit
    end
  end
  def destroy
    @employee.destroy

    redirect_to employees_path
  end
  private
  def set_employee
    @employee = Employee.find params[:id]
  end
  def employee_params
    params.require(:employee).permit(:user_name, :password, :password_confirmation)
  end

  def permission_params permissible
    permissible.permit(:can_manage)
  end
end
