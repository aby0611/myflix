shared_examples "require sign in"  do
	it "redirect to the sign in page" do
		session[:user_id] = nil
		action
		expect(response).to redirect_to sign_in_path
	end
end

shared_examples "tokenable"  do
  it "generates a random token when the object is created" do
    expect(object.token).to be_present
  end
end