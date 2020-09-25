onerror { resume }
set curr_transcript [transcript]
transcript off

add wave /tb/svpcie/endp0_clk_clk
add wave /tb/svpcie/endp0_rx_st_data
add wave /tb/svpcie/endp0_rx_st_empty
add wave /tb/svpcie/endp0_rx_st_endofpacket
add wave /tb/svpcie/endp0_rx_st_error
add wave /tb/svpcie/endp0_rx_st_ready
add wave /tb/svpcie/endp0_rx_st_startofpacket
add wave /tb/svpcie/endp0_rx_st_valid
add wave /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_unsupported
add wave /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_type
add wave /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_masked_address
add wave /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_tag
add wave /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_requester_id
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_data
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_empty
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_endofpacket
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_error
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_ready
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_startofpacket
add wave /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_valid
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_data
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_empty
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_endofpacket
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_error
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_ready
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_startofpacket
add wave /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_valid
add wave /tb/svpcie/tlp_mux_out_channel
add wave /tb/svpcie/tlp_mux_out_data
add wave /tb/svpcie/tlp_mux_out_empty
add wave /tb/svpcie/tlp_mux_out_endofpacket
add wave /tb/svpcie/tlp_mux_out_ready
add wave /tb/svpcie/tlp_mux_out_startofpacket
add wave /tb/svpcie/tlp_mux_out_valid
add wave /tb/svpcie/endp0_rx_bar_be_rx_st_bar
add wave /tb/svpcie/endp0_tx_cred_tx_cons_cred_sel
add wave /tb/svpcie/endp0_tx_cred_tx_cred_datafccp
add wave /tb/svpcie/endp0_tx_cred_tx_cred_datafcnp
add wave /tb/svpcie/endp0_tx_cred_tx_cred_datafcp
add wave /tb/svpcie/endp0_tx_cred_tx_cred_fchipcons
add wave /tb/svpcie/endp0_tx_cred_tx_cred_fcinfinite
add wave /tb/svpcie/endp0_tx_cred_tx_cred_hdrfccp
add wave /tb/svpcie/endp0_tx_cred_tx_cred_hdrfcnp
add wave /tb/svpcie/endp0_tx_cred_tx_cred_hdrfcp
add wave /tb/svpcie/fejkon_pcie_data_mem_access_req_data
add wave /tb/svpcie/fejkon_pcie_data_mem_access_req_ready
add wave /tb/svpcie/fejkon_pcie_data_mem_access_req_valid
add wave /tb/svpcie/fejkon_pcie_avalon/mem_access_req_address
add wave /tb/svpcie/fejkon_pcie_avalon_mem_access_resp_data
add wave /tb/svpcie/fejkon_pcie_avalon_mem_access_resp_ready
add wave /tb/svpcie/fejkon_pcie_avalon_mem_access_resp_valid
add wave /tb/svpcie/fejkon_pcie_avalon_mm_address
add wave /tb/svpcie/fejkon_pcie_avalon_mm_byteenable
add wave /tb/svpcie/fejkon_pcie_avalon_mm_writedata
add wave /tb/svpcie/fejkon_pcie_avalon_mm_read
add wave /tb/svpcie/fejkon_pcie_avalon_mm_write
add wave /tb/svpcie/fejkon_pcie_avalon_mm_readdatavalid
add wave /tb/svpcie/fejkon_pcie_avalon_mm_waitrequest
add wave /tb/svpcie/fejkon_pcie_avalon_mm_response
add wave /tb/svpcie/fejkon_pcie_avalon_mm_readdata
add wave /tb/svpcie/fejkon_pcie_avalon_mm_writeresponsevalid
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_valid
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_endofpacket
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_startofpacket
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_empty
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_data
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_endofpacket
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_startofpacket
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_valid
add wave /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_empty
wv.cursors.add -time 91900ns -name {Default cursor}
wv.cursors.setactive -name {Default cursor}
wv.zoom.range -from 30400ns -to 130216010ps
wv.time.unit.auto.set
transcript $curr_transcript
