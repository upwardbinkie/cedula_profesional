class StaticPagesController < ApplicationController
  def home
    @cedulas = Cedula.distinct.count('cedula_number')
    @titles = Cedula.distinct.count('title')
    @institutions = Cedula.distinct.count('institution')
  end

  def about
  end

  def faq
  end

  def privacy
  end

  def terms
  end
end
