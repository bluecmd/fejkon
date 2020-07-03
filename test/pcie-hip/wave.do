onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/svpcie/endp0_clk_clk
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_data
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_empty
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_endofpacket
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_error
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_ready
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_startofpacket
add wave -noupdate -group phy_rx_st /tb/svpcie/endp0_rx_st_valid
add wave -noupdate -expand -group rx_frm -color Gold /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_unsupported
add wave -noupdate -expand -group rx_frm /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_type
add wave -noupdate -expand -group rx_frm -radix hexadecimal /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_masked_address
add wave -noupdate -expand -group rx_frm /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_tag
add wave -noupdate -expand -group rx_frm /tb/svpcie/fejkon_pcie_data/tlp_rx_frm_requester_id
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_data
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_empty
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_endofpacket
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_error
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_ready
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_startofpacket
add wave -noupdate -group phy_tx_st /tb/svpcie/intel_pcie_tlp_adapter_phy_tx_st_valid
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_data
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_empty
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_endofpacket
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_error
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_ready
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_startofpacket
add wave -noupdate -group tlp_rx_st /tb/svpcie/intel_pcie_tlp_adapter_tlp_rx_st_valid
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_channel
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_data
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_empty
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_endofpacket
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_ready
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_startofpacket
add wave -noupdate -group tlp_tx_st /tb/svpcie/tlp_mux_out_valid
add wave -noupdate -group rx_bar /tb/svpcie/endp0_rx_bar_be_rx_st_bar
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cons_cred_sel
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_datafccp
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_datafcnp
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_datafcp
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_fchipcons
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_fcinfinite
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_hdrfccp
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_hdrfcnp
add wave -noupdate -group tx_cred /tb/svpcie/endp0_tx_cred_tx_cred_hdrfcp
add wave -noupdate -group mem_req /tb/svpcie/fejkon_pcie_data_mem_access_req_data
add wave -noupdate -group mem_req /tb/svpcie/fejkon_pcie_data_mem_access_req_ready
add wave -noupdate -group mem_req /tb/svpcie/fejkon_pcie_data_mem_access_req_valid
add wave -noupdate -group mem_req /tb/svpcie/fejkon_pcie_avalon/mem_access_req_address
add wave -noupdate -group mem_resp /tb/svpcie/fejkon_pcie_avalon_mem_access_resp_data
add wave -noupdate -group mem_resp /tb/svpcie/fejkon_pcie_avalon_mem_access_resp_ready
add wave -noupdate -group mem_resp /tb/svpcie/fejkon_pcie_avalon_mem_access_resp_valid
add wave -noupdate -expand -group mm_pcie /tb/svpcie/fejkon_pcie_avalon_mm_address
add wave -noupdate -expand -group mm_pcie /tb/svpcie/fejkon_pcie_avalon_mm_byteenable
add wave -noupdate -expand -group mm_pcie /tb/svpcie/fejkon_pcie_avalon_mm_writedata
add wave -noupdate -expand -group mm_pcie -color Gold /tb/svpcie/fejkon_pcie_avalon_mm_read
add wave -noupdate -expand -group mm_pcie -color Gold /tb/svpcie/fejkon_pcie_avalon_mm_write
add wave -noupdate -expand -group mm_pcie -color Turquoise /tb/svpcie/fejkon_pcie_avalon_mm_readdatavalid
add wave -noupdate -expand -group mm_pcie -color Turquoise /tb/svpcie/fejkon_pcie_avalon_mm_waitrequest
add wave -noupdate -expand -group mm_pcie /tb/svpcie/fejkon_pcie_avalon_mm_response
add wave -noupdate -expand -group mm_pcie /tb/svpcie/fejkon_pcie_avalon_mm_readdata
add wave -noupdate -expand -group mm_pcie /tb/svpcie/fejkon_pcie_avalon_mm_writeresponsevalid
add wave -noupdate -group apps_tx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_valid
add wave -noupdate -group apps_tx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_endofpacket
add wave -noupdate -group apps_tx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_startofpacket
add wave -noupdate -group apps_tx_st -childformat {{{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[255]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[254]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[253]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[252]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[251]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[250]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[249]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[248]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[247]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[246]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[245]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[244]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[243]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[242]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[241]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[240]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[239]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[238]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[237]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[236]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[235]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[234]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[233]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[232]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[231]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[230]} -radix hexadecimal} {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[229]} -radix hexadecimal}} -subitemconfig {{/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[255]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[254]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[253]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[252]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[251]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[250]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[249]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[248]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[247]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[246]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[245]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[244]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[243]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[242]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[241]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[240]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[239]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[238]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[237]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[236]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[235]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[234]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[233]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[232]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[231]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[230]} {-height 16 -radix hexadecimal} {/tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data[229]} {-height 16 -radix hexadecimal}} /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_data
add wave -noupdate -group apps_tx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/apps_tx_st_empty
add wave -noupdate -group apps_rx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_data
add wave -noupdate -group apps_rx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_endofpacket
add wave -noupdate -group apps_rx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_startofpacket
add wave -noupdate -group apps_rx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_valid
add wave -noupdate -group apps_rx_st /tb/svpcie/root/g_bfm_top_rp/altpcietb_bfm_top_rp/g_bfm/genblk1/rp/inst/dut_rx_st_empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {97283498 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 577
configure wave -valuecolwidth 536
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {95029582 ps} {99470574 ps}
