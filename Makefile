####################################################################################################
# Configuration
####################################################################################################

DOCS = md
BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = Ecm_guide
METADATA = metadata.yml
SITE_DIR = html
# PDF_DIR = $(SITE_DIR)/pdf
# EPUB_DIR = $(SITE_DIR)/epub
# HTML_DIR = $(SITE_DIR)/html
EXTRA_FILES_DIR = files
PDF_DIR = $(EXTRA_FILES_DIR)
EPUB_DIR = $(EXTRA_FILES_DIR)
HTML_DIR = $(EXTRA_FILES_DIR)

CHAPTERS = md/*.md
# build from ls -1 md then replace ^ replace \n
# to manage order (index) and content

# TODO : remove list and use tags : pdf.md, epub.md, keep *.md and only change file to index.html : easier !
PDF_CHAPTERS =  md/00-CoverPage.md  md/index.md  md/02-Reference.md  md/03-Avertissement.md  md/04-EnSavoirPlus.md  md/05-SurLaTablette.md  md/06-Nouveautes.md  md/09-LesDeuxModes.md  md/10-ParcoursEleve.md  md/20-ParcoursProfesseur.md  md/21-BoutonsMedias.md  md/22-MesEleves.md  md/23-MesDocuments.md  md/24-Observables.md  md/25-Reglages.md  md/26-Aide.md  md/27-APropos.md  md/28-PageEleve.md  md/29-PageDocument.md  md/30-GenererECarnet.md  md/80-ManipulationsDiverses.md  md/85-21-tutoPartageParents.md  md/70-FAQ.md  md/90-RGDP.md  md/91-Credits.md  md/92-Evolutions.md  md/93-Bugs.md  

#CHAPTERS_WO_COMMENTS = md/*.mdwocomments
CHAPTERS_WO_COMMENTS =  md/00-CoverPage.md.mdwocomments  md/index.md.mdwocomments  md/02-Reference.md.mdwocomments  md/03-Avertissement.md.mdwocomments  md/04-EnSavoirPlus.md.mdwocomments  md/05-SurLaTablette.md.mdwocomments  md/06-Nouveautes.md.mdwocomments  md/09-LesDeuxModes.md.mdwocomments  md/10-ParcoursEleve.md.mdwocomments  md/20-ParcoursProfesseur.md.mdwocomments  md/21-BoutonsMedias.md.mdwocomments  md/22-MesEleves.md.mdwocomments  md/23-MesDocuments.md.mdwocomments  md/24-Observables.md.mdwocomments  md/25-Reglages.md.mdwocomments  md/26-Aide.md.mdwocomments  md/27-APropos.md.mdwocomments  md/28-PageEleve.md.mdwocomments  md/29-PageDocument.md.mdwocomments  md/30-GenererECarnet.md.mdwocomments  md/80-ManipulationsDiverses.md.mdwocomments   md/70-FAQ.md.mdwocomments  md/90-RGDP.md.mdwocomments  md/91-Credits.md.mdwocomments  md/92-Evolutions.md.mdwocomments  md/93-Bugs.md.mdwocomments  

TOC = --toc --toc-depth=4 
IMAGES_FOLDER = md/screenshots
IMAGES = $(IMAGES_FOLDER)/*
CSS_FOLDER = css
TEX_FOLDER = tex
COVER_IMAGE = $(IMAGES_FOLDER)/logo_eportfolio2.cropped.arrondi.png
MATH_FORMULAS = --webtex

CSS_FILE = markdown.github.e-portfolio.css
CSS_FILE_EPUB = markdown.github.e-portfolio.epub.css

CSS_ARG = --css=./css/$(CSS_FILE)
CSS_EPUB_ARG = --css=./css/$(CSS_FILE_EPUB)

TEX_TEMPLATE_PORTRAIT = readme_template.tex
TEX_TEMPLATE_PAYSAGE = readme_template_tablette.tex
TEX_PORTRAIT_ARG = --template=./tex/$(TEX_TEMPLATE_PORTRAIT)
TEX_PAYSAGE_ARG = --template=./tex/$(TEX_TEMPLATE_PAYSAGE)

METADATA_ARG = --metadata-file=$(METADATA)
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) $(METADATA_ARG)

HTML_ARGS = --number-sections --standalone --to=html5
PDF_ARGS_original = -V geometry:margin=1in -V documentclass=report --pdf-engine=xelatex
PDF_ARGS = -V geometry:margin=1in -V documentclass=book --pdf-engine=xelatex --metadata=abstract:" "
PDF_ARGS = -V geometry:margin=1cm -V documentclass=scrbook --pdf-engine=xelatex --metadata=abstract:" "
PDF_ARGS_testKO = -V geometry:margin=1in -V documentclass=report --pdf-engine=pdflatex

####################################################################################################
# Basic actions
####################################################################################################

all:	ecm_guide

ecm_guide:	 html1page pdf pdf2 epub html

clean:
	rm -r $(BUILD)

####################################################################################################
# File builders
####################################################################################################

html:	$(BUILD)/$(SITE_DIR)/$(OUTPUT_FILENAME).html

html1page:	$(DOCS)/$(HTML_DIR)/$(OUTPUT_FILENAME).html

pdf: $(DOCS)/$(PDF_DIR)/$(OUTPUT_FILENAME)_portrait.pdf
pdf2: $(DOCS)/$(PDF_DIR)/$(OUTPUT_FILENAME)_paysage.pdf

epub:	$(DOCS)/$(EPUB_DIR)/$(OUTPUT_FILENAME).epub

zip: $(BUILD)/zip/$(OUTPUT_FILENAME).zip

# slides

# md/*.mdwocomments: 
# 	# script .md > .mdwocomments : clean comments <!--.*-->
# 	#for f in $(CHAPTERS);do echo 'Processing : $(f) file...'; done
# 	#sh ./scripts/removeCommentsInMDfiles.sh
# 	sh ./scripts/mdTomdwocommentsFiles.sh
# 	node ./scripts/removeCommentsInMDfiles.js

$(PDF_CHAPTERS):
#

$(CHAPTERS_WO_COMMENTS):
	sh ./scripts/mdTomdwocommentsFiles.sh
	node ./scripts/removeCommentsInMDfiles.js

$(DOCS)/$(EPUB_DIR)/$(OUTPUT_FILENAME).epub:	$(MAKEFILE) $(METADATA) $(CHAPTERS_WO_COMMENTS) $(CSS_FOLDER)/$(CSS_FILE_EPUB) $(IMAGES) $(COVER_IMAGE)
	mkdir -p $(BUILD)/$(EPUB_DIR)
	#
	# Building epub with PANDOC...
	#
	pandoc $(TOC) $(MATH_FORMULAS) $(CSS_EPUB_ARG) $(METADATA_ARG) --epub-cover-image=$(COVER_IMAGE) -o $@ $(CHAPTERS_WO_COMMENTS) --verbose
	#
	# remove .mdwocomments files
	#
	sh ./scripts/cleanFilesMdWoComments.sh

	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> BUILT !"
	@echo "-------------------------------------------------------------"

	cp $(DOCS)/$(EPUB_DIR)/$(OUTPUT_FILENAME).epub $(BUILD)/$(PDF_DIR)/$(OUTPUT_FILENAME).epub
	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> MOVED !"
	@echo "-------------------------------------------------------------"

# html1page : 
$(DOCS)/$(HTML_DIR)/$(OUTPUT_FILENAME).html:	$(MAKEFILE) $(METADATA) $(PDF_CHAPTERS) $(CSS_FOLDER)/$(CSS_FILE) $(IMAGES)
	#
	# Building html1page with PANDOC...
	#
	#mkdir -p $(BUILD)/$(HTML_DIR)
	#mkdir -p $(BUILD)/html/$(IMAGES_FOLDER)
	#mkdir -p $(BUILD)/$(HTML_DIR)/$(CSS_FOLDER)
	#pandoc $(ARGS) $(HTML_ARGS) -o $@ $(PDF_CHAPTERS) --verbose
	pandoc $(ARGS) $(HTML_ARGS) -o  $(DOCS)/$(OUTPUT_FILENAME).html $(PDF_CHAPTERS) --verbose
	
	#cp -R $(IMAGES_FOLDER)/ $(BUILD)/html/$(IMAGES_FOLDER)/
	#cp -R $(IMAGES_FOLDER)/ $(BUILD)/$(HTML_DIR)/screenshots/
	#cp -R $(IMAGES_FOLDER)/ screenshots/
	#cp $(CSS_FOLDER)/$(CSS_FILE) $(BUILD)/$(HTML_DIR)/$(CSS_FOLDER)/$(CSS_FILE)
	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> BUILT !"
	@echo "-------------------------------------------------------------"
	
	cp $(DOCS)/$(OUTPUT_FILENAME).html $(BUILD)/$(PDF_DIR)/$(OUTPUT_FILENAME).html
	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> MOVED !"
	@echo "-------------------------------------------------------------"


$(BUILD)/$(SITE_DIR)/$(OUTPUT_FILENAME).html:	$(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FOLDER)/$(CSS_FILE) $(IMAGES)
	mkdocs build
	node ./scripts/ga/insertGAtag.js

$(DOCS)/$(PDF_DIR)/$(OUTPUT_FILENAME)_portrait.pdf:	$(MAKEFILE) $(METADATA) $(PDF_CHAPTERS) $(CSS_FOLDER)/$(CSS_FILE) $(IMAGES) $(TEX_FOLDER)/$(TEX_TEMPLATE_PORTRAIT)
	mkdir -p $(BUILD)/$(PDF_DIR)
	# remove video part whare are not compatible with pdf
	# that is all between <!-- startNonPdf -->  and <!-- endNonPdf --> tags
	# need to remove newline to avoid multiline substitution
		# cat md/05-ModeEmploi.md | tr '\n' '£' > md/05-ModeEmploi.md1
		# sed -Ee 's/(\<\!\-\- startNonPdf \-\-\>((.+£)+)\<\!\-\- endNonPdf \-\-\>)//g' md/05-ModeEmploi.md1 > md/05-ModeEmploi.md2
		# cat md/05-ModeEmploi.md2 | tr '£' '\n' > md/05-ModeEmploi.sansVideo.md

	#remove original from pipeline : rename md/05-ModeEmploi.md into md/05-ModeEmploi.md0
		# mv md/05-ModeEmploi.md  md/05-ModeEmploi.md0

	pandoc $(ARGS) $(PDF_PORTRAIT_ARGS) $(TEX_PORTRAIT_ARG) -o $@ --verbose $(PDF_CHAPTERS) 

	# come back : rename md/05-ModeEmploi.md0 into md/05-ModeEmploi.md
		# mv md/05-ModeEmploi.md0  md/05-ModeEmploi.md
		# rm md/05-ModeEmploi.md1
		# rm md/05-ModeEmploi.md2

	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> BUILT !"
	@echo "-------------------------------------------------------------"

	cp $(DOCS)/$(PDF_DIR)/$(OUTPUT_FILENAME)_portrait.pdf $(BUILD)/$(PDF_DIR)/$(OUTPUT_FILENAME)_portrait.pdf
	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> MOVED !"
	@echo "-------------------------------------------------------------"


$(DOCS)/$(PDF_DIR)/$(OUTPUT_FILENAME)_paysage.pdf:	$(MAKEFILE) $(METADATA) $(PDF_CHAPTERS) $(CSS_FOLDER)/$(CSS_FILE) $(IMAGES) $(TEX_FOLDER)/$(TEX_TEMPLATE_PORTRAIT)
	mkdir -p $(BUILD)/$(PDF_DIR)
	pandoc $(ARGS) $(PDF_PAYSAGE_ARGS) $(TEX_PAYSAGE_ARG) -o $@ --verbose $(PDF_CHAPTERS) 
	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> BUILT !"
	@echo "-------------------------------------------------------------"

	cp $(DOCS)/$(PDF_DIR)/$(OUTPUT_FILENAME)_paysage.pdf $(BUILD)/$(PDF_DIR)/$(OUTPUT_FILENAME)_paysage.pdf
	@echo "-------------------------------------------------------------"
	@echo ">>>> $@ >>>>> MOVED !"
	@echo "-------------------------------------------------------------"


$(BUILD)/zip/$(OUTPUT_FILENAME).zip: 
	#$(BUILD)/epub/$(OUTPUT_FILENAME).epub $(BUILD)/html/$(OUTPUT_FILENAME).html $(BUILD)/pdf_portrait/$(OUTPUT_FILENAME)_portrait.pdf $(BUILD)/pdf_paysage/$(OUTPUT_FILENAME)_paysage.pdf
	mkdir -p zip
	#zip -r zip/$(OUTPUT_FILENAME).zip $(BUILD)
	zip -r zip/$(OUTPUT_FILENAME).tousFormats.zip $(BUILD)/epub $(BUILD)/html $(BUILD)/pdf_paysage $(BUILD)/pdf_portrait
	#zip $(BUILD)/zip/$(OUTPUT_FILENAME).zip $(BUILD)/epub/$(OUTPUT_FILENAME).epub $(BUILD)/html/$(OUTPUT_FILENAME).html $(BUILD)/pdf_portrait/$(OUTPUT_FILENAME)_portrait.pdf $(BUILD)/pdf_paysage/$(OUTPUT_FILENAME)_paysage.pdf 
	@echo "-------------------------------------------------------------"
	@echo ">>>> $(OUTPUT_FILENAME) >>>>> ZIPPED !"
	@echo "-------------------------------------------------------------"

	