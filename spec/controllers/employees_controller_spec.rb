require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
  let!(:owner){
    FactoryGirl.build(:retailer)
  }
  let(:valid_attributes) {
    {user_name: FFaker::Internet.user_name,  password: '12345678', password_confirmation: '12345678', owner: owner, user_type: 'Employee'}
  }

  let(:invalid_attributes) {
    {user_name: nil,  password: '12345678', password_confirmation: '12345678', owner: owner, user_type: 'Employee'}
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    login_retailer

    it "assigns all employees as @employees" do
      employee = Employee.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:employees)).to eq([])
    end
  end

  describe "GET #show" do
    login_retailer

    it "assigns the requested employee as @employee" do
      employee = Employee.create! valid_attributes
      get :show, {:id => employee.to_param}, valid_session
      expect(assigns(:employee)).to eq(employee)
    end
  end

  describe "GET #new" do
    login_retailer

    it "assigns a new employee as @employee" do
      get :new, {}, valid_session
      expect(assigns(:employee)).to be_a_new(Employee)
    end
  end

  describe "GET #edit" do
    login_retailer

    it "assigns the requested employee as @employee" do
      employee = Employee.create! valid_attributes
      get :edit, {:id => employee.to_param}, valid_session
      expect(assigns(:employee)).to eq(employee)
    end
  end

  describe "POST #create" do
    login_retailer

    context "with valid params" do
      it "creates a new Employee" do
        expect {
          post :create, {:employee => valid_attributes}, valid_session
        }.to change(Employee, :count).by(1)
      end

      it "assigns a newly created employee as @employee" do
        post :create, {:employee => valid_attributes}, valid_session
        expect(assigns(:employee)).to be_a(Employee)
        expect(assigns(:employee)).to be_persisted
      end

      it "redirects to the created employee" do
        post :create, {:employee => valid_attributes}, valid_session
        expect(response).to redirect_to(employees_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved employee as @employee" do
        post :create, {:employee => invalid_attributes}, valid_session
        expect(assigns(:employee)).to be_a_new(Employee)
      end

      it "re-renders the 'new' template" do
        post :create, {:employee => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    login_retailer

    context "with valid params" do
      let(:new_attributes) {
        { user_name: 'valid updated title' }
      }

      it "updates the requested employee" do
        employee = Employee.create! valid_attributes
        put :update, {:id => employee.to_param, :employee => new_attributes}, valid_session
        employee.reload
	expect(employee.user_name).to eq new_attributes[:user_name]
      end

      it "assigns the requested employee as @employee" do
        employee = Employee.create! valid_attributes
        put :update, {:id => employee.to_param, :employee => valid_attributes}, valid_session
        expect(assigns(:employee)).to eq(employee)
      end

      it "redirects to the employee" do
        employee = Employee.create! valid_attributes
        put :update, {:id => employee.to_param, :employee => valid_attributes}, valid_session
        expect(response).to redirect_to(employee)
      end
    end

    context "with invalid params" do
      it "assigns the employee as @employee" do
        employee = Employee.create! valid_attributes
        put :update, {:id => employee.to_param, :employee => invalid_attributes}, valid_session
        expect(assigns(:employee)).to eq(employee)
      end

      it "re-renders the 'edit' template" do
        employee = Employee.create! valid_attributes
        put :update, {:id => employee.to_param, :employee => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    login_retailer

    it "destroys the requested employee" do
      employee = Employee.create! valid_attributes
      expect {
        delete :destroy, {:id => employee.to_param}, valid_session
      }.to change(Employee, :count).by(-1)
    end

    it "redirects to the employees list" do
      employee = Employee.create! valid_attributes
      delete :destroy, {:id => employee.to_param}, valid_session
      expect(response).to redirect_to(employees_url)
    end
  end
end
