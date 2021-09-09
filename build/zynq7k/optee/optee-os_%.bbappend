OPTEEMACHINE = "zynq7k-zc702"
COMPATIBLE_MACHINE_zynq = "zynq-generic|ultra96-zynq"


EXTRA_OEMAKE_append = " CFG_TEE_CORE_LOG_LEVEL=3 CFG_TEE_TA_LOG_LEVEL=3"

PLNX_DEPLOY_DIR ?= "${TOPDIR}/images/linux"

do_compile_append() {
	${S}/scripts/gen_tee_bin.py --input ${B}/core/tee.elf --out_tee_raw_bin ${B}/core/tee_raw.bin
}

do_install_append() {
        install -m 644 ${B}/core/tee.elf ${D}${nonarch_base_libdir}/firmware/tee.elf
}

deploy_optee() {
	install -d ${PLNX_DEPLOY_DIR}
	install -m 644 ${DEPLOYDIR}/optee/tee_raw.bin ${PLNX_DEPLOY_DIR}/tee_raw.bin
	install -m 644 ${DEPLOYDIR}/optee/tee.elf ${PLNX_DEPLOY_DIR}/bl32.elf
}

do_deploy[postfuncs] += " deploy_optee"
do_deploy_setscene[postfuncs] += " deploy_optee"
