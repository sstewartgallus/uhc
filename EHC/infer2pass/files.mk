# location of infer2pass src
INF2PS_SRC_PREFIX						:= $(TOP_PREFIX)infer2pass/

# location of infer2pass build
#INF2PS_BLD_PREFIX						:= $(BLD_PREFIX)infer2pass/

# end products, binary, executable, etc
INF2PS_EXEC_NAME						:= infer2pass
INF2PS_BLD_EXEC							:= $(INF2PS_BLD_BIN_VARIANT_PREFIX)$(INF2PS_EXEC_NAME)$(EXEC_SUFFIX)
INF2PS_ALL_EXECS						:= $(patsubst %,$(INF2PS_BIN_PREFIX)$(INF2PS_VARIANT_EXTRA)%/$(INF2PS_EXEC_NAME)$(EXEC_SUFFIX),$(INF2PS_VARIANTS))

# shuffle order
INF2PS_SHUFFLE_ORDER					:= 1 < 2 < 3

# this file
INF2PS_MKF								:= $(INF2PS_SRC_PREFIX)files.mk

# main + sources + dpds
INF2PS_MAIN								:= Infer2Pass

INF2PS_RL_RULES_BASE					:= RulerInfer2Pass
INF2PS_RL_RULES_SRC_RUL					:= $(addprefix $(INF2PS_SRC_PREFIX),$(INF2PS_RL_RULES_BASE).rul)
INF2PS_RL_RULES_DRV_AG					:= $(patsubst $(INF2PS_SRC_PREFIX)%.rul,$(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_RL_RULES_SRC_RUL))

INF2PS_HS_MAIN_SRC_CHS					:= $(addprefix $(INF2PS_SRC_PREFIX),$(INF2PS_MAIN).chs)
INF2PS_HS_MAIN_DRV_HS					:= $(patsubst $(INF2PS_SRC_PREFIX)%.chs,$(INF2PS_BLD_VARIANT_PREFIX)%.hs,$(INF2PS_HS_MAIN_SRC_CHS))
INF2PS_HS_DPDS_SRC_CHS					:= $(patsubst %,$(INF2PS_SRC_PREFIX)%.chs,Infer2PassSupport)
INF2PS_HS_DPDS_DRV_HS					:= $(patsubst $(INF2PS_SRC_PREFIX)%.chs,$(INF2PS_BLD_VARIANT_PREFIX)%.hs,$(INF2PS_HS_DPDS_SRC_CHS))

INF2PS_AGMAIN_MAIN_SRC_CAG				:= $(patsubst %,$(INF2PS_SRC_PREFIX)%.cag,MainAG)
INF2PS_AGMAIN_MAIN_DRV_AG				:= $(patsubst $(INF2PS_SRC_PREFIX)%.cag,$(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_AGMAIN_MAIN_SRC_CAG))
INF2PS_AGMAIN_DPDS_DRV_AG				:= $(patsubst %,$(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_RL_RULES_BASE) \
											)
$(patsubst $(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_BLD_VARIANT_PREFIX)%.hs,$(INF2PS_AGMAIN_MAIN_DRV_AG)) \
										: $(INF2PS_AGMAIN_DPDS_DRV_AG)

INF2PS_AG_D_MAIN_SRC_CAG				:= 
INF2PS_AG_S_MAIN_SRC_CAG				:= 
INF2PS_AG_DS_MAIN_SRC_CAG				:= $(INF2PS_AGMAIN_MAIN_SRC_CAG)

INF2PS_AG_ALL_MAIN_SRC_CAG				:= $(INF2PS_AG_DS_MAIN_SRC_CAG) $(INF2PS_AG_S_MAIN_SRC_CAG) $(INF2PS_AG_D_MAIN_SRC_CAG)

INF2PS_AG_D_MAIN_DRV_AG					:= 
INF2PS_AG_S_MAIN_DRV_AG					:= 
INF2PS_AG_DS_MAIN_DRV_AG				:= $(patsubst $(INF2PS_SRC_PREFIX)%.cag,$(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_AG_DS_MAIN_SRC_CAG))

INF2PS_AG_ALL_MAIN_DRV_AG				:= $(INF2PS_AG_D_MAIN_DRV_AG) $(INF2PS_AG_S_MAIN_DRV_AG) $(INF2PS_AG_DS_MAIN_DRV_AG)

# all src
INF2PS_ALL_SRC							:= $(INF2PS_AG_ALL_MAIN_SRC_CAG) $(INF2PS_HS_MAIN_SRC_CHS) $(INF2PS_HS_DPDS_SRC_CHS) $(INF2PS_RL_RULES_SRC_RUL)

# derived
INF2PS_AG_D_MAIN_DRV_HS					:= $(patsubst $(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_BLD_VARIANT_PREFIX)%.hs,$(INF2PS_AG_D_MAIN_DRV_AG))
INF2PS_AG_S_MAIN_DRV_HS					:= $(patsubst $(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_BLD_VARIANT_PREFIX)%.hs,$(INF2PS_AG_S_MAIN_DRV_AG))
INF2PS_AG_DS_MAIN_DRV_HS				:= $(patsubst $(INF2PS_BLD_VARIANT_PREFIX)%.ag,$(INF2PS_BLD_VARIANT_PREFIX)%.hs,$(INF2PS_AG_DS_MAIN_DRV_AG))
INF2PS_AG_ALL_MAIN_DRV_HS				:= $(INF2PS_AG_D_MAIN_DRV_HS) $(INF2PS_AG_S_MAIN_DRV_HS) $(INF2PS_AG_DS_MAIN_DRV_HS)

INF2PS_HS_ALL_DRV_HS					:= $(INF2PS_HS_MAIN_DRV_HS) $(INF2PS_HS_DPDS_DRV_HS)

# distribution
INF2PS_DIST_FILES						:= $(INF2PS_ALL_SRC) $(INF2PS_MKF)

# all dependents for a variant to kick of building
INF2PS_ALL_DPDS							:= $(INF2PS_HS_ALL_DRV_HS) $(INF2PS_AG_ALL_MAIN_DRV_HS)

# what is based on which Ruler view
INF2PS_ON_RULES_VIEW_1					:= HM
INF2PS_ON_RULES_VIEW_2					:= K
INF2PS_ON_RULES_VIEW_3					:= I

INF2PS_BY_RULER_GROUPS_BASE				:= expr.base tyexpr.base

INF2PS_BY_RULER_RULES_BASE				:= *
INF2PS_BY_RULER_RULES_3					:= $(INF2PS_BY_RULER_RULES_BASE)
INF2PS_BY_RULER_RULES_2					:= $(INF2PS_BY_RULER_RULES_3)
INF2PS_BY_RULER_RULES_1					:= $(INF2PS_BY_RULER_RULES_2)

# variant dispatch rules
$(INF2PS_ALL_EXECS): %: $(INF2PS_ALL_SRC) $(INF2PS_MKF)
	$(MAKE) INF2PS_VARIANT=`echo $(notdir $(*D)) | sed -e 's/^$(INF2PS_VARIANT_EXTRA)//'` infer2pass-variant

# make rules
infer2pass-variant: 
	$(MAKE) INF2PS_VARIANT_RULER_SEL="(($(INF2PS_VARIANT)=$(INF2PS_ON_RULES_VIEW_$(INF2PS_VARIANT)))).($(INF2PS_BY_RULER_GROUPS_BASE)).($(INF2PS_BY_RULER_RULES_$(INF2PS_VARIANT)))" \
	  infer2pass-variant-dflt

infer2pass-variant-dflt: $(INF2PS_ALL_DPDS)
	mkdir -p $(dir $(INF2PS_BLD_EXEC))
	$(GHC) --make $(GHC_OPTS) -i$(INF2PS_BLD_VARIANT_PREFIX) -i$(LIB_SRC_PREFIX) $(INF2PS_BLD_VARIANT_PREFIX)$(INF2PS_MAIN).hs -o $(INF2PS_BLD_EXEC)

#$(INF2PS_BLD_EXEC): $(INF2PS_AG_ALL_MAIN_DRV_HS) $(INF2PS_HS_ALL_DRV_HS) $(LIB_SRC_HS)
#	$(GHC) --make $(GHC_OPTS) $(GHC_OPTS_OPTIM) -i$(INF2PS_BLD_VARIANT_PREFIX) $(INF2PS_BLD_VARIANT_PREFIX)$(INF2PS_MAIN).hs -o $@
#	strip $@

$(INF2PS_RL_RULES_DRV_AG): $(INF2PS_RL_RULES_SRC_RUL) $(RULER2)
	mkdir -p $(@D) ; \
	$(RULER2) $(RULER2_OPTS) --ag --ATTR --DATA --selrule="$(INF2PS_VARIANT_RULER_SEL)" --base=$(*F) $< > $@

$(INF2PS_AG_D_MAIN_DRV_HS): $(INF2PS_BLD_VARIANT_PREFIX)%.hs: $(INF2PS_BLD_VARIANT_PREFIX)%.ag
	mkdir -p $(@D) ; \
	$(AGC) --module=$(*F) -dr -P"$(INF2PS_SRC_PREFIX)" -P"$(INF2PS_BLD_VARIANT_PREFIX)" -o $@ $<

$(INF2PS_AG_S_MAIN_DRV_HS): $(INF2PS_BLD_VARIANT_PREFIX)%.hs: $(INF2PS_BLD_VARIANT_PREFIX)%.ag
	mkdir -p $(@D) ; \
	$(AGC) -cfspr -P"$(INF2PS_SRC_PREFIX)" -P"$(INF2PS_BLD_VARIANT_PREFIX)" -o $@ $<

$(INF2PS_AG_DS_MAIN_DRV_HS): $(INF2PS_BLD_VARIANT_PREFIX)%.hs: $(INF2PS_BLD_VARIANT_PREFIX)%.ag
	mkdir -p $(@D) ; \
	$(AGC) -dcfspr -P"$(INF2PS_SRC_PREFIX)" -P"$(INF2PS_BLD_VARIANT_PREFIX)" -o $@ $<

#$(INF2PS_HS_ALL_DRV_HS): $(INF2PS_BLD_VARIANT_PREFIX)%.hs: $(INF2PS_SRC_PREFIX)%.hs
#	mkdir -p $(@D) ; \
#	cp $< $@

$(INF2PS_HS_MAIN_DRV_HS): $(INF2PS_BLD_VARIANT_PREFIX)%.hs: $(INF2PS_SRC_PREFIX)%.chs $(SHUFFLE)
	mkdir -p $(@D)
	$(SHUFFLE) --gen=$(INF2PS_VARIANT) --base=Main --hs --preamble=no --lhs2tex=no --order="$(INF2PS_SHUFFLE_ORDER)" $< > $@

$(INF2PS_HS_DPDS_DRV_HS): $(INF2PS_BLD_VARIANT_PREFIX)%.hs: $(INF2PS_SRC_PREFIX)%.chs $(SHUFFLE)
	mkdir -p $(@D)
	$(SHUFFLE) --gen=$(INF2PS_VARIANT) --base=$(*F) --hs --preamble=no --lhs2tex=no --order="$(INF2PS_SHUFFLE_ORDER)" $< > $@

$(INF2PS_AG_ALL_MAIN_DRV_AG) $(INF2PS_AG_ALL_DPDS_DRV_AG): $(INF2PS_BLD_VARIANT_PREFIX)%.ag: $(INF2PS_SRC_PREFIX)%.cag $(SHUFFLE)
	mkdir -p $(@D)
	$(SHUFFLE) --gen=$(INF2PS_VARIANT) --base=$(*F) --ag --preamble=no --lhs2tex=no --order="$(INF2PS_SHUFFLE_ORDER)" $< > $@

