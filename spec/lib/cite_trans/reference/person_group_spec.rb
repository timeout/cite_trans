require 'cite_trans/reference/person_group'

RSpec.describe CiteTrans::Reference::PersonGroup do

  let(:person_group) { CiteTrans::Reference::PersonGroup.new }

  it 'adds a name' do
    person_group.add_name(surname: 'Holland', given_names: 'WG')
  end

  it 'includes a surname?' do
    person_group.add_name(surname: 'Holland', given_names: 'WG')
    expect(person_group.include?('Holland')).to be_truthy
  end
  
  it "doesn't include surname?" do
    expect(person_group.include? 'Hoelle').to be_falsey
  end

  #  describe '#format' do
  #    it 'formats people according to a style formatter' do
  #      apa_formatter = double("APA Formatter")
  #      person_group.format(apa_formatter)
  #    end
  #  end

  describe '#empty?' do
    it "is empty?" do
      expect(person_group.empty?).to be_truthy
    end

    it "isn't empty?" do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      expect(person_group.empty?).to be_falsey
    end
  end

  describe '#size' do
    it 'has size 1' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      expect(person_group.size).to eq(1)
    end

    it 'has size 3' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      person_group.add_name(surname: 'Thanh', given_names: 'NG')
      person_group.add_name(surname: 'My', given_names: 'LN')
      expect(person_group.size).to eq(3)
    end
  end

  describe '#<=>' do
      let(:other_group) { CiteTrans::Reference::PersonGroup.new }

    it 'Holland is less than James' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      other_group.add_name(surname: 'James', given_names: 'Troy')
      expect(person_group <=> other_group).to eq(-1)
    end

    it 'James is greater than Holland' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      other_group.add_name(surname: 'James', given_names: 'Troy')
      expect(other_group <=> person_group).to eq(1)
    end

    it 'Troy James is equal to Troy James' do
      person_group.add_name(surname: 'James', given_names: 'Troy')
      other_group.add_name(surname: 'James', given_names: 'Troy')
      expect(other_group <=> person_group).to eq(0)
    end

    it 'Troy James is less than Willian James' do
      person_group.add_name(surname: 'James', given_names: 'Troy')
      other_group.add_name(surname: 'James', given_names: 'William')
      expect(person_group <=> other_group).to eq(-1)
    end

    it 'William James is more than Troy James' do
      person_group.add_name(surname: 'James', given_names: 'Troy')
      other_group.add_name(surname: 'James', given_names: 'William')
      expect(other_group <=> person_group).to eq(1)
    end

    it 'Will is less than Willian' do
      person_group.add_name(surname: 'Will', given_names: 'Troy')
      other_group.add_name(surname: 'Willian', given_names: 'William')
      expect(person_group <=> other_group).to eq(-1)
    end

    it 'James, William & Gatland, Daniel < James, William & Uithol, Jason' do
      person_group.add_name(surname: 'James', given_names: 'William')
      person_group.add_name(surname: 'Gatland', given_names: 'Daniel')
      other_group.add_name(surname: 'James', given_names: 'William')
      other_group.add_name(surname: 'Uithol', given_names: 'Jason')
      expect(person_group <=> other_group).to eq(-1)
    end

    it 'James, William < James, William & Uithol, Jason' do
      person_group.add_name(surname: 'James', given_names: 'William')
      other_group.add_name(surname: 'James', given_names: 'William')
      other_group.add_name(surname: 'Uithol', given_names: 'Jason')
      expect(person_group <=> other_group).to eq(-1)
    end

    it 'James, William & Uithol, Jason > James, William' do
      person_group.add_name(surname: 'James', given_names: 'William')
      other_group.add_name(surname: 'James', given_names: 'William')
      other_group.add_name(surname: 'Uithol', given_names: 'Jason')
      expect(other_group <=> person_group).to eq(1)
    end

    it 'is not equal' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      expect(person_group <=> other_group).to be_nil
    end

    it 'is not equal if both authors are nil' do
      expect(person_group == other_group).to be_falsey
      expect(person_group <=> other_group).to be_nil
    end

    it 'is equal' do
      person_group.add_name(surname: 'Holland', given_names: 'WG')
      other_group.add_name(surname: 'Holland', given_names: 'WG')
      expect(person_group == other_group).to be_truthy
    end
  end
end
