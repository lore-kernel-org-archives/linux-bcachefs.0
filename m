Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BB825F983;
	Mon, 24 Mar 2025 17:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742835649; cv=none; b=d96q/y9svfBm+tIaNDQnbcUn5rOzsHWTcBqo9Ae8nN23HiUTzXAqP5zWSq2lvLGx75+PxxEz+n3HY48gIXehtIyZaBZlt28DpDFQsKB7KuavO3YK6HeB2gfqj+bv1NUMbgXUfgNIJoxg/fs4AIdQ582iQWYJohfjgmJRamYD90M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742835649; c=relaxed/simple;
	bh=hRwdc7GAv02/CDRRqPxL+xxcdu0Gm/kXtixSxLppqvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKNOnhXIwo9KoNeWia92buKWVGCjTQm/EIRYA+LH4EnJL3w/loMogzNjIofS6MlyhqH1gJSekWoes8Lws7LbqXhYXmyVU2a8g/f7ZJADlyK0/ZpIb0Hs7FnvGYrLs5Z4nMx9xqSnID184tFAPjpC7ZAPuWKJ+fYl10SffqLW4/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iUbqIrQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iUbqIrQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D88C4CEE9;
	Mon, 24 Mar 2025 17:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742835648;
	bh=hRwdc7GAv02/CDRRqPxL+xxcdu0Gm/kXtixSxLppqvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iUbqIrQRQcBtCVPe6xpH+G0WTxr5MDWLJ67WohNgAfHWJ0r/YcTlQ3NUtRAZjnkMz
	 /LiOqGwWavHILAtt17/5vQ3AM26BzappiJXuqKFv2rbv7DB+bjoWiIIClEXp2aAmUv
	 Ra6JavmekNyRFOP904vnFLshnDeO0nQFp8PuIwM7p61FpkNap5tzEkwSDGev7h9+Ho
	 iZIGGrgCWYSi2+reU5J7udV/MU7BhKGl1M6UcwraCtDWjyRby9Vc1G7fGZ3RX6XxTQ
	 5u15K2k+OB5wqw113B9pAFLhRtKzcTooN71S+GzO5bI8IIigs77OwXkJ6WW7Sohw1u
	 SryyMkaePeznQ==
Date: Mon, 24 Mar 2025 17:00:46 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hui Guo <guohui.study@gmail.com>, linux-bcachefs@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in poly1305_update_arch
Message-ID: <20250324170046.GA19087@google.com>
References: <CAHOo4gLWAbArwg+w+AqqkxGmOFX6cm8Tvy85tb4igN6V7Z9BZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHOo4gLWAbArwg+w+AqqkxGmOFX6cm8Tvy85tb4igN6V7Z9BZQ@mail.gmail.com>

This is a bcachefs issue.

+linux-bcachefs@vger.kernel.org

In the future, when fuzzing a filesystem please direct any bugs found directly
to the mailing list for the corresponding filesystem.

On Mon, Mar 24, 2025 at 08:05:29PM +0800, Hui Guo wrote:
> Hi Kernel Maintainers,
> we found a crash "KASAN: use-after-free Read in poly1305_update_arch"
> (it is a KASAN and makes the kernel reboot) in upstream, we also have
> successfully reproduced it manually:
> 
> HEAD Commit: 586de92313fcab8ed84ac5f78f4d2aae2db92c59
> kernel config: https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/a29967be967eebf049e89edb14c4edf9991bc929/.config
> 
> console output:
> https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/586de92313fcab8ed84ac5f78f4d2aae2db92c59/f3745555675b1b16c0ddf549fbd72fb975100195/repro.log
> repro report: https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/586de92313fcab8ed84ac5f78f4d2aae2db92c59/f3745555675b1b16c0ddf549fbd72fb975100195/repro.report
> syz reproducer:
> https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/586de92313fcab8ed84ac5f78f4d2aae2db92c59/f3745555675b1b16c0ddf549fbd72fb975100195/repro.prog
> c reproducer: https://raw.githubusercontent.com/androidAppGuard/KernelBugs/refs/heads/main/586de92313fcab8ed84ac5f78f4d2aae2db92c59/f3745555675b1b16c0ddf549fbd72fb975100195/repro.cprog
> 
> Please let me know if there is anything I can help with.
> Best,
> Hui Guo
> 
> 
> This is the crash log I got by reproducing the bug based on the above
> environment，
> I have piped this log through decode_stacktrace.sh to better
> understand the cause of the bug.
> =============================================================================================
> 2025/03/24 11:50:17 parsed 1 programs
> [ 84.317117][ T9599] Adding 124996k swap on ./swap-file. Priority:0
> extents:1 across:124996k
> [ 85.846374][ T60] audit: type=1400 audit(1742817027.690:8): avc:
> denied { execmem } for pid=9615 comm="syz-executor"
> scontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> tcontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> tclass=process permissive=1
> [ 85.970995][ T9653] Bluetooth: hci0: unexpected cc 0x0c03 length: 249 > 1
> [ 85.974096][ T9653] Bluetooth: hci0: unexpected cc 0x1003 length: 249 > 9
> [ 85.980118][ T9653] Bluetooth: hci0: unexpected cc 0x1001 length: 249 > 9
> [ 85.997135][ T9653] Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > 4
> [ 85.998658][ T9653] Bluetooth: hci0: unexpected cc 0x0c25 length: 249 > 3
> [ 86.000139][ T9653] Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > 2
> [ 86.273149][ T60] audit: type=1401 audit(1742817028.110:9):
> op=setxattr invalid_context="u:object_r:app_data_file:s0:c512,c768"
> [ 86.464134][ T1151] wlan0: Created IBSS using preconfigured BSSID
> 50:50:50:50:50:50
> [ 86.465682][ T1151] wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
> [ 86.504503][ T96] wlan1: Created IBSS using preconfigured BSSID
> 50:50:50:50:50:50
> [ 86.505750][ T96] wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> [ 86.526978][ T9637] chnl_net:caif_netlink_parms(): no params data found
> [ 86.589108][ T9637] bridge0: port 1(bridge_slave_0) entered blocking state
> [ 86.590934][ T9637] bridge0: port 1(bridge_slave_0) entered disabled state
> [ 86.591956][ T9637] bridge_slave_0: entered allmulticast mode
> [ 86.593729][ T9637] bridge_slave_0: entered promiscuous mode
> [ 86.596288][ T9637] bridge0: port 2(bridge_slave_1) entered blocking state
> [ 86.597273][ T9637] bridge0: port 2(bridge_slave_1) entered disabled state
> [ 86.598304][ T9637] bridge_slave_1: entered allmulticast mode
> [ 86.599650][ T9637] bridge_slave_1: entered promiscuous mode
> [ 86.625741][ T9637] bond0: (slave bond_slave_0): Enslaving as an
> active interface with an up link
> [ 86.628209][ T9637] bond0: (slave bond_slave_1): Enslaving as an
> active interface with an up link
> [ 86.655584][ T9637] team0: Port device team_slave_0 added
> [ 86.657634][ T9637] team0: Port device team_slave_1 added
> [ 86.688129][ T9637] batman_adv: batadv0: Adding interface: batadv_slave_0
> [ 86.688984][ T9637] batman_adv: batadv0: The MTU of interface
> batadv_slave_0 is too small (1500) to handle the transport of
> batman-adv packets. Packets going over this interface will be
> fragmented on layer2 which could impact the performance. Setting the
> MTU to 1560 would solve the problem.
> [ 86.691855][ T9637] batman_adv: batadv0: Not using interface
> batadv_slave_0 (retrying later): interface not active
> [ 86.696337][ T9637] batman_adv: batadv0: Adding interface: batadv_slave_1
> [ 86.697241][ T9637] batman_adv: batadv0: The MTU of interface
> batadv_slave_1 is too small (1500) to handle the transport of
> batman-adv packets. Packets going over this interface will be
> fragmented on layer2 which could impact the performance. Setting the
> MTU to 1560 would solve the problem.
> [ 86.700500][ T9637] batman_adv: batadv0: Not using interface
> batadv_slave_1 (retrying later): interface not active
> [ 86.739582][ T9637] hsr_slave_0: entered promiscuous mode
> [ 86.740760][ T9637] hsr_slave_1: entered promiscuous mode
> [ 86.870829][ T9637] netdevsim netdevsim7 netdevsim0: renamed from eth0
> [ 86.875475][ T9637] netdevsim netdevsim7 netdevsim1: renamed from eth1
> [ 86.878531][ T9637] netdevsim netdevsim7 netdevsim2: renamed from eth2
> [ 86.881574][ T9637] netdevsim netdevsim7 netdevsim3: renamed from eth3
> [ 86.897919][ T9637] bridge0: port 2(bridge_slave_1) entered blocking state
> [ 86.898935][ T9637] bridge0: port 2(bridge_slave_1) entered forwarding state
> [ 86.900314][ T9637] bridge0: port 1(bridge_slave_0) entered blocking state
> [ 86.901516][ T9637] bridge0: port 1(bridge_slave_0) entered forwarding state
> [ 86.936584][ T9637] 8021q: adding VLAN 0 to HW filter on device bond0
> [ 86.950832][ T96] bridge0: port 1(bridge_slave_0) entered disabled state
> [ 86.955164][ T96] bridge0: port 2(bridge_slave_1) entered disabled state
> [ 86.966527][ T9637] 8021q: adding VLAN 0 to HW filter on device team0
> [ 86.972683][ T3579] bridge0: port 1(bridge_slave_0) entered blocking state
> [ 86.973793][ T3579] bridge0: port 1(bridge_slave_0) entered forwarding state
> [ 86.978878][ T96] bridge0: port 2(bridge_slave_1) entered blocking state
> [ 86.979967][ T96] bridge0: port 2(bridge_slave_1) entered forwarding state
> [ 87.008199][ T9637] hsr0: Slave B (hsr_slave_1) is not up; please
> bring it up to get a fully working HSR network
> [ 87.108957][ T9637] 8021q: adding VLAN 0 to HW filter on device batadv0
> [ 87.256320][ T9637] veth0_vlan: entered promiscuous mode
> [ 87.260969][ T9637] veth1_vlan: entered promiscuous mode
> [ 87.277472][ T9637] veth0_macvtap: entered promiscuous mode
> [ 87.280374][ T9637] veth1_macvtap: entered promiscuous mode
> [ 87.290443][ T9637] batman_adv: batadv0: Interface activated: batadv_slave_0
> [ 87.295969][ T9637] batman_adv: batadv0: Interface activated: batadv_slave_1
> [ 87.299447][ T9637] netdevsim netdevsim7 netdevsim0: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 87.300756][ T9637] netdevsim netdevsim7 netdevsim1: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 87.301968][ T9637] netdevsim netdevsim7 netdevsim2: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 87.304774][ T9637] netdevsim netdevsim7 netdevsim3: set [1, 0] type
> 2 family 0 port 6081 - 0
> 2025/03/24 11:50:29 executed programs: 0
> [ 87.415821][ T85] Bluetooth: hci1: unexpected cc 0x0c03 length: 249 > 1
> [ 87.418787][ T85] Bluetooth: hci1: unexpected cc 0x1003 length: 249 > 9
> [ 87.420546][ T85] Bluetooth: hci1: unexpected cc 0x1001 length: 249 > 9
> [ 87.422241][ T85] Bluetooth: hci1: unexpected cc 0x0c23 length: 249 > 4
> [ 87.424108][ T85] Bluetooth: hci1: unexpected cc 0x0c25 length: 249 > 3
> [ 87.425385][ T85] Bluetooth: hci1: unexpected cc 0x0c38 length: 249 > 2
> [ 87.509901][T11019] chnl_net:caif_netlink_parms(): no params data found
> [ 87.563201][T11019] bridge0: port 1(bridge_slave_0) entered blocking state
> [ 87.564637][T11019] bridge0: port 1(bridge_slave_0) entered disabled state
> [ 87.565479][T11019] bridge_slave_0: entered allmulticast mode
> [ 87.566585][T11019] bridge_slave_0: entered promiscuous mode
> [ 87.568503][T11019] bridge0: port 2(bridge_slave_1) entered blocking state
> [ 87.569538][T11019] bridge0: port 2(bridge_slave_1) entered disabled state
> [ 87.570614][T11019] bridge_slave_1: entered allmulticast mode
> [ 87.571860][T11019] bridge_slave_1: entered promiscuous mode
> [ 87.602767][T11019] bond0: (slave bond_slave_0): Enslaving as an
> active interface with an up link
> [ 87.608519][T11019] bond0: (slave bond_slave_1): Enslaving as an
> active interface with an up link
> [ 87.634579][T11019] team0: Port device team_slave_0 added
> [ 87.636573][T11019] team0: Port device team_slave_1 added
> [ 87.660148][T11019] batman_adv: batadv0: Adding interface: batadv_slave_0
> [ 87.661048][T11019] batman_adv: batadv0: The MTU of interface
> batadv_slave_0 is too small (1500) to handle the transport of
> batman-adv packets. Packets going over this interface will be
> fragmented on layer2 which could impact the performance. Setting the
> MTU to 1560 would solve the problem.
> [ 87.665631][T11019] batman_adv: batadv0: Not using interface
> batadv_slave_0 (retrying later): interface not active
> [ 87.667657][T11019] batman_adv: batadv0: Adding interface: batadv_slave_1
> [ 87.668523][T11019] batman_adv: batadv0: The MTU of interface
> batadv_slave_1 is too small (1500) to handle the transport of
> batman-adv packets. Packets going over this interface will be
> fragmented on layer2 which could impact the performance. Setting the
> MTU to 1560 would solve the problem.
> [ 87.671697][T11019] batman_adv: batadv0: Not using interface
> batadv_slave_1 (retrying later): interface not active
> [ 87.717200][T11019] hsr_slave_0: entered promiscuous mode
> [ 87.718492][T11019] hsr_slave_1: entered promiscuous mode
> [ 87.719592][T11019] debugfs: Directory 'hsr0' with parent 'hsr'
> already present!
> [ 87.720959][T11019] Cannot create hsr debugfs directory
> [ 87.827241][T11019] netdevsim netdevsim0 netdevsim0: renamed from eth0
> [ 87.829744][T11019] netdevsim netdevsim0 netdevsim1: renamed from eth1
> [ 87.832224][T11019] netdevsim netdevsim0 netdevsim2: renamed from eth2
> [ 87.835215][T11019] netdevsim netdevsim0 netdevsim3: renamed from eth3
> [ 87.847029][T11019] bridge0: port 2(bridge_slave_1) entered blocking state
> [ 87.847885][T11019] bridge0: port 2(bridge_slave_1) entered forwarding state
> [ 87.848778][T11019] bridge0: port 1(bridge_slave_0) entered blocking state
> [ 87.849602][T11019] bridge0: port 1(bridge_slave_0) entered forwarding state
> [ 87.872807][T11019] 8021q: adding VLAN 0 to HW filter on device bond0
> [ 87.880118][ T13] bridge0: port 1(bridge_slave_0) entered disabled state
> [ 87.883677][ T13] bridge0: port 2(bridge_slave_1) entered disabled state
> [ 87.895124][T11019] 8021q: adding VLAN 0 to HW filter on device team0
> [ 87.900930][ T97] bridge0: port 1(bridge_slave_0) entered blocking state
> [ 87.902120][ T97] bridge0: port 1(bridge_slave_0) entered forwarding state
> [ 87.908002][T11294] bridge0: port 2(bridge_slave_1) entered blocking state
> [ 87.909741][T11294] bridge0: port 2(bridge_slave_1) entered forwarding state
> [ 88.032278][T11019] 8021q: adding VLAN 0 to HW filter on device batadv0
> [ 88.034050][ T85] Bluetooth: hci0: command tx timeout
> [ 88.055135][T11019] veth0_vlan: entered promiscuous mode
> [ 88.059506][T11019] veth1_vlan: entered promiscuous mode
> [ 88.074272][T11019] veth0_macvtap: entered promiscuous mode
> [ 88.077239][T11019] veth1_macvtap: entered promiscuous mode
> [ 88.085062][T11019] batman_adv: The newly added mac address
> (aa:aa:aa:aa:aa:3e) already exists on: batadv_slave_0
> [ 88.086633][T11019] batman_adv: It is strongly recommended to keep
> mac addresses unique to avoid problems!
> [ 88.088956][T11019] batman_adv: batadv0: Interface activated: batadv_slave_0
> [ 88.094524][T11019] batman_adv: The newly added mac address
> (aa:aa:aa:aa:aa:3f) already exists on: batadv_slave_1
> [ 88.095959][T11019] batman_adv: It is strongly recommended to keep
> mac addresses unique to avoid problems!
> [ 88.098273][T11019] batman_adv: batadv0: Interface activated: batadv_slave_1
> [ 88.101977][T11019] netdevsim netdevsim0 netdevsim0: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 88.104171][T11019] netdevsim netdevsim0 netdevsim1: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 88.105401][T11019] netdevsim netdevsim0 netdevsim2: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 88.106599][T11019] netdevsim netdevsim0 netdevsim3: set [1, 0] type
> 2 family 0 port 6081 - 0
> [ 88.140817][ T13] wlan0: Created IBSS using preconfigured BSSID
> 50:50:50:50:50:50
> [ 88.142392][ T13] wlan0: Creating new IBSS network, BSSID 50:50:50:50:50:50
> [ 88.155795][ T96] wlan1: Created IBSS using preconfigured BSSID
> 50:50:50:50:50:50
> [ 88.156973][ T96] wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> [ 88.314757][T12039] loop0: detected capacity change from 0 to 32768
> [ 88.346885][T12039] bcachefs (loop0): starting version 1.7:
> mi_btree_bitmap
> opts=metadata_checksum=none,data_checksum=xxhash,nojournal_transaction_names
> [ 88.348824][T12039] bcachefs (loop0): recovering from clean shutdown,
> journal seq 10
> [ 88.349815][T12039] bcachefs (loop0): Doing compatible version
> upgrade from 1.7: mi_btree_bitmap to 1.20: directory_size
> [ 88.349815][T12039] running recovery passes:
> check_allocations,check_extents_to_backpointers,check_inodes
> [ 88.360566][T12039] bcachefs (loop0): error validating btree node on
> loop0 at btree alloc level 0/0
> [ 88.360581][T12039] u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0:
> seq 4fe84214937890c3 written 32 min_key POS_MIN durability: 1 ptr:
> 0:26:0 gen 0
> [ 88.360589][T12039] node offset 8/32 bset u64s 375: checksum error,
> type chacha20_poly1305_128: got 5125f248dce6c8583c1006bcb40e6d91
> should be 56f8c5dd15dee062262778682ebef4d2, shutting down
> [ 88.367016][T12039] bcachefs (loop0): inconsistency detected -
> emergency read only at journal seq 10
> [ 88.368285][T12039] bcachefs (loop0): flagging btree alloc lost data
> [ 88.369242][T12039] bcachefs (loop0): running explicit recovery pass
> check_topology (2), currently at recovery_pass_empty (0)
> [ 88.370747][T12039] bcachefs (loop0): running explicit recovery pass
> check_lrus (14), currently at recovery_pass_empty (0)
> [ 88.372157][T12039] bcachefs (loop0): running explicit recovery pass
> check_backpointers_to_extents (16), currently at recovery_pass_empty
> (0)
> [ 88.373924][T12039] bcachefs (loop0): running explicit recovery pass
> check_alloc_info (13), currently at recovery_pass_empty (0)
> [ 88.377400][T12039] error reading btree root btree=alloc level=0:
> btree_node_read_error, fixing
> [ 88.380073][T12039]
> ==================================================================
> [88.381083][T12039] BUG: KASAN: use-after-free in poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [ 88.382059][T12039] Read of size 8 at addr ffff8880496c7050 by task
> syz.0.15/12039
> [ 88.383042][T12039]
> [ 88.383346][T12039] CPU: 3 UID: 0 PID: 12039 Comm: syz.0.15 Not
> tainted 6.14.0-rc7-00205-g586de92313fc #1
> [ 88.383357][T12039] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.15.0-1 04/01/2014
> [ 88.383363][T12039] Call Trace:
> [ 88.383367][T12039] <TASK>
> [88.383371][T12039] dump_stack_lvl
> (/data/ghui/docker_data/linux_kernel/upstream/linux/lib/dump_stack.c:123)
> [88.383385][T12039] print_report
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/report.c:409
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/report.c:521)
> [88.383398][T12039] ? __phys_addr
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/mm/physaddr.c:32
> (discriminator 4))
> [88.383408][T12039] ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [88.383420][T12039] ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [88.383432][T12039] kasan_report
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/report.c:636)
> [88.383443][T12039] ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:196)
> [88.383455][T12039] ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [88.383468][T12039] kasan_check_range
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/generic.c:183
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/generic.c:189)
> [88.383481][T12039] __asan_memcpy
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/shadow.c:105)
> [88.383490][T12039] poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [88.383503][T12039] crypto_poly1305_update
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:232)
> [88.383515][T12039] bch2_checksum
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/checksum.c:240)
> [88.383527][T12039] ? __pfx_bch2_checksum
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/checksum.c:213)
> [88.383539][T12039] ? rcu_is_watching
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/context_tracking.h:128
> /data/ghui/docker_data/linux_kernel/upstream/linux/kernel/rcu/tree.c:716)
> [88.383550][T12039] ? kfree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/trace/events/kmem.h:94
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4744)
> [88.383566][T12039] ? bch2_journal_seq_is_blacklisted
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/journal_seq_blacklist.c:131)
> [88.383580][T12039] bch2_btree_node_read_done
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1130)
> [88.383598][T12039] ? bch2_bkey_pick_read_device
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:347
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:880
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:173)
> [88.383611][T12039] ? __pfx_bch2_btree_node_read_done
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1009)
> [88.383625][T12039] ? bch2_bkey_pick_read_device
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:119)
> [88.383634][T12039] ? __pfx___lock_acquire
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5079)
> [88.383650][T12039] ? __pfx_bch2_bkey_pick_read_device
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:119)
> [88.383661][T12039] ? bch2_mark_io_failure
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:61
> (discriminator 2))
> [88.383672][T12039] ? btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1357
> (discriminator 1))
> [88.383680][T12039] btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1357
> (discriminator 1))
> [88.383688][T12039] ? lockdep_hardirqs_on
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:4470)
> [88.383702][T12039] ? __pfx_btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1312)
> [88.383711][T12039] ? bch2_latency_acct
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/io_write.c:66)
> [88.383723][T12039] ? __pfx_bch2_latency_acct
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/io_write.c:66)
> [88.383735][T12039] bch2_btree_node_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1748)
> [88.383745][T12039] ? __pfx_bch2_btree_node_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1685)
> [88.383753][T12039] ? find_held_lock
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5341)
> [88.383765][T12039] ? __pfx_lock_release
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5859)
> [88.383777][T12039] ? __bch2_trans_unlock
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_iter.h:111
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_locking.c:725)
> [88.383787][T12039] ? __pfx_bch2_btree_cache_cmp_fn
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_cache.c:135)
> [88.383799][T12039] bch2_btree_root_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/instrumented.h:68
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/asm-generic/bitops/instrumented-non-atomic.h:141
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_types.h:628
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1791
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1811)
> [88.383808][T12039] ? __pfx___mutex_unlock_slowpath
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/mutex.c:885)
> [88.383820][T12039] ? __pfx_bch2_btree_root_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1810)
> [88.383832][T12039] bch2_fs_recovery
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:581
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:928)
> [88.383848][T12039] ? __pfx_bch2_fs_recovery
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:699)
> [88.383863][T12039] ? bch2_get_next_online_dev
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:347
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:880
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/sb-members.h:157)
> [88.383874][T12039] ? __pfx_lock_release
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5859)
> [88.383889][T12039] ? bch2_get_next_online_dev
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/sb-members.h:160)
> [88.383900][T12039] ? llist_reverse_order
> (/data/ghui/docker_data/linux_kernel/upstream/linux/lib/llist.c:115)
> [88.383915][T12039] ? __closure_wake_up
> (/data/ghui/docker_data/linux_kernel/upstream/linux/lib/closure.c:89)
> [88.383925][T12039] bch2_fs_start
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1041)
> [88.383940][T12039] bch2_fs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2204)
> [88.383950][T12039] ? __pfx_bch2_fs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2160)
> [88.383958][T12039] ? lock_acquire
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5824)
> [88.383974][T12039] ? rcu_is_watching
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/context_tracking.h:128
> /data/ghui/docker_data/linux_kernel/upstream/linux/kernel/rcu/tree.c:716)
> [88.383986][T12039] ? bpf_lsm_capable
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/lsm_hook_defs.h:44)
> [88.383999][T12039] ? security_capable
> (/data/ghui/docker_data/linux_kernel/upstream/linux/security/security.c:1143
> (discriminator 120))
> [88.384013][T12039] vfs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/super.c:1815)
> [88.384027][T12039] path_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3561
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3887)
> [88.384039][T12039] ? kmem_cache_free
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4609
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4711)
> [88.384048][T12039] ? __pfx_path_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3814)
> [88.384060][T12039] ? putname.part.0
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namei.c:297)
> [88.384073][T12039] __x64_sys_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3901
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4111
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088)
> [88.384084][T12039] ? __pfx___x64_sys_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088)
> [88.384097][T12039] do_syscall_64
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/common.c:52
> /data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/common.c:83)
> [88.384109][T12039] entry_SYSCALL_64_after_hwframe
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/entry_64.S:130)
> [ 88.384123][T12039] RIP: 0033:0x7f7c16f9e49e
> [ 88.384131][T12039] Code: 48 c7 c0 ff ff ff ff eb aa e8 5e 20 00 00
> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 a5
> 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8
> 64 89 01 48
> All code
> ========
> 0: 48 c7 c0 ff ff ff ff mov $0xffffffffffffffff,%rax
> 7: eb aa jmp 0xffffffffffffffb3
> 9: e8 5e 20 00 00 call 0x206c
> e: 66 2e 0f 1f 84 00 00 cs nopw 0x0(%rax,%rax,1)
> 15: 00 00 00
> 18: 0f 1f 40 00 nopl 0x0(%rax)
> 1c: f3 0f 1e fa endbr64
> 20: 49 89 ca mov %rcx,%r10
> 23: b8 a5 00 00 00 mov $0xa5,%eax
> 28: 0f 05 syscall
> 2a:* 48 3d 01 f0 ff ff cmp $0xfffffffffffff001,%rax <-- trapping instruction
> 30: 73 01 jae 0x33
> 32: c3 ret
> 33: 48 c7 c1 a8 ff ff ff mov $0xffffffffffffffa8,%rcx
> 3a: f7 d8 neg %eax
> 3c: 64 89 01 mov %eax,%fs:(%rcx)
> 3f: 48 rex.W
> 
> Code starting with the faulting instruction
> ===========================================
> 0: 48 3d 01 f0 ff ff cmp $0xfffffffffffff001,%rax
> 6: 73 01 jae 0x9
> 8: c3 ret
> 9: 48 c7 c1 a8 ff ff ff mov $0xffffffffffffffa8,%rcx
> 10: f7 d8 neg %eax
> 12: 64 89 01 mov %eax,%fs:(%rcx)
> 15: 48 rex.W
> [ 88.384140][T12039] RSP: 002b:00007f7c17ce4da8 EFLAGS: 00000246
> ORIG_RAX: 00000000000000a5
> [ 88.384149][T12039] RAX: ffffffffffffffda RBX: 00000000000119f4 RCX:
> 00007f7c16f9e49e
> [ 88.384156][T12039] RDX: 0000000020011a00 RSI: 0000000020000000 RDI:
> 00007f7c17ce4e00
> [ 88.384162][T12039] RBP: 00007f7c17ce4e40 R08: 00007f7c17ce4e40 R09:
> 0000000000000000
> [ 88.384167][T12039] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000020011a00
> [ 88.384173][T12039] R13: 0000000020000000 R14: 00007f7c17ce4e00 R15:
> 0000000020000100
> [ 88.384195][T12039] </TASK>
> [ 88.384198][T12039]
> [ 88.434820][T12039] The buggy address belongs to the physical page:
> [ 88.435543][T12039] page: refcount:0 mapcount:0
> mapping:0000000000000000 index:0x0 pfn:0x496c7
> [ 88.436519][T12039] flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
> [ 88.437336][T12039] raw: 00fff00000000000 0000000000000000
> dead000000000122 0000000000000000
> [ 88.438312][T12039] raw: 0000000000000000 0000000000000000
> 00000000ffffffff 0000000000000000
> [ 88.439298][T12039] page dumped because: kasan: bad access detected
> [ 88.440027][T12039] page_owner tracks the page as freed
> [ 88.440651][T12039] page last allocated via order 5, migratetype
> Reclaimable, gfp_mask
> 0x452cd0(GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_RECLAIMABLE),
> pid 12039, tgid 12038 (syz.0.15), ts 88328445083, free_ts 88379542461
> [88.443083][T12039] post_alloc_hook
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/page_owner.h:32
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:1551)
> [88.443647][T12039] get_page_from_freelist
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:1561
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:3477)
> [88.444281][T12039] __alloc_frozen_pages_noprof
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:4741)
> [88.444952][T12039] __alloc_pages_noprof
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:4775)
> [88.445534][T12039] ___kmalloc_large_node
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4232)
> [88.446133][T12039] __kmalloc_large_node_noprof
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./arch/x86/include/asm/bitops.h:417
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/asm-generic/getorder.h:46
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4268)
> [88.446800][T12039] __kmalloc_node_noprof
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./arch/x86/include/asm/bitops.h:417
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/asm-generic/getorder.h:46
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4284
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4300)
> [88.447416][T12039] __kvmalloc_node_noprof
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/util.c:668)
> [88.448024][T12039] btree_node_data_alloc.constprop.0
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_cache.c:156)
> [88.448747][T12039] __bch2_btree_node_mem_alloc
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_cache.c:201)
> [88.449392][T12039] bch2_fs_btree_cache_init
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_cache.c:655)
> [88.450026][T12039] bch2_fs_alloc
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:919)
> [88.450582][T12039] bch2_fs_open
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/err.h:116
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:2066)
> [88.451115][T12039] bch2_fs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/err.h:116
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2191)
> [88.451702][T12039] vfs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/super.c:1815)
> [88.452226][T12039] path_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3561
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3887)
> [ 88.452735][T12039] page last free pid 12039 tgid 12038 stack trace:
> [88.453481][T12039] __free_pages_ok
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/page_owner.h:25
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:1127
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/page_alloc.c:1271)
> [88.454058][T12039] __folio_put
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/swap.c:112)
> [88.454577][T12039] kvfree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/util.c:709)
> [88.455012][T12039] bch2_btree_node_read_done
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:111
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1243)
> [88.455689][T12039] btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1357
> (discriminator 1))
> [88.456291][T12039] bch2_btree_node_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1748)
> [88.456878][T12039] bch2_btree_root_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/instrumented.h:68
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/asm-generic/bitops/instrumented-non-atomic.h:141
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_types.h:628
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1791
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1811)
> [88.457472][T12039] bch2_fs_recovery
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:581
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:928)
> [88.458035][T12039] bch2_fs_start
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1041)
> [88.458565][T12039] bch2_fs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2204)
> [88.459139][T12039] vfs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/super.c:1815)
> [88.459647][T12039] path_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3561
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3887)
> [88.460144][T12039] __x64_sys_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3901
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4111
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088)
> [88.460722][T12039] do_syscall_64
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/common.c:52
> /data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/common.c:83)
> [88.461243][T12039] entry_SYSCALL_64_after_hwframe
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/entry_64.S:130)
> [ 88.461903][T12039]
> [ 88.462174][T12039] Memory state around the buggy address:
> [ 88.462801][T12039] ffff8880496c6f00: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [ 88.463717][T12039] ffff8880496c6f80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [ 88.464735][T12039] >ffff8880496c7000: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [ 88.465763][T12039] ^
> [ 88.466619][T12039] ffff8880496c7080: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [ 88.467647][T12039] ffff8880496c7100: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [ 88.468677][T12039]
> ==================================================================
> [ 88.469819][T12039] Kernel panic - not syncing: KASAN: panic_on_warn set ...
> [ 88.470749][T12039] CPU: 3 UID: 0 PID: 12039 Comm: syz.0.15 Not
> tainted 6.14.0-rc7-00205-g586de92313fc #1
> [ 88.471966][T12039] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.15.0-1 04/01/2014
> [ 88.473133][T12039] Call Trace:
> 12039] <TASK>[T
> 
> [88.474112][T12039] dump_stack_lvl
> (/data/ghui/docker_data/linux_kernel/upstream/linux/lib/dump_stack.c:124
> (discriminator 7))
> essage f[ 88.474971][Tr12039] panic+0xo6fd/0x7b0
> m sy[ s 8l8.o4g75d6@12s]y[Tzk12a039l]l e ?r mark_held_locks
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:4323)
> at [ M a8r8. 4276440 2]1[1T:125003:9] ? __pfx_panic
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/panic.c:288)
> 70 [ . . 8.8.
> 71 1k2]e[rTn12e0l39] ? irqentry_exit
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/entry/common.c:358)
> :[ [8888..47748566]9[T819]12[039] ? lockdep_hardirqs_on
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:4470)
> T12[ 0 3889.47]86 66K][eTrn12e03l9] p ? check_panic_on_warn
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/panic.c:242)
> ani[ c 8-8.4 7945n4o][tT s12y0n3c9i] check_panic_on_warn
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/panic.c:243)
> ng:[ 8K8A.S4A8N024:9 ][pTa120n3i9]c end_report
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/report.c:227)
> _on[ _ w 8a8r.4n80 97s6]e[Tt12 03.9]. . ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> 
> [88.481811][T12039] kasan_report
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./arch/x86/include/asm/smap.h:52
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/report.c:639)
> [88.482363][T12039] ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:196)
> [88.483019][T12039] ? poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [88.483664][T12039] kasan_check_range
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/generic.c:183
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/generic.c:189)
> [88.484229][T12039] __asan_memcpy
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/kasan/shadow.c:105)
> [88.484735][T12039] poly1305_update_arch
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:198)
> [88.485333][T12039] crypto_poly1305_update
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/crypto/poly1305_glue.c:232)
> [88.485922][T12039] bch2_checksum
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/checksum.c:240)
> [88.486453][T12039] ? __pfx_bch2_checksum
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/checksum.c:213)
> [88.487035][T12039] ? rcu_is_watching
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/context_tracking.h:128
> /data/ghui/docker_data/linux_kernel/upstream/linux/kernel/rcu/tree.c:716)
> [88.487588][T12039] ? kfree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/trace/events/kmem.h:94
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4744)
> [88.488064][T12039] ? bch2_journal_seq_is_blacklisted
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/journal_seq_blacklist.c:131)
> [88.488806][T12039] bch2_btree_node_read_done
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1130)
> [88.489490][T12039] ? bch2_bkey_pick_read_device
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:347
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:880
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:173)
> [88.490261][T12039] ? __pfx_bch2_btree_node_read_done
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1009)
> [88.491058][T12039] ? bch2_bkey_pick_read_device
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:119)
> [88.491835][T12039] ? __pfx___lock_acquire
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5079)
> [88.492511][T12039] ? __pfx_bch2_bkey_pick_read_device
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:119)
> [88.493328][T12039] ? bch2_mark_io_failure
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/extents.c:61
> (discriminator 2))
> [88.494005][T12039] ? btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1357
> (discriminator 1))
> [88.494747][T12039] btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1357
> (discriminator 1))
> [88.495440][T12039] ? lockdep_hardirqs_on
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:4470)
> [88.496116][T12039] ? __pfx_btree_node_read_work
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1312)
> [88.496858][T12039] ? bch2_latency_acct
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/io_write.c:66)
> [88.497530][T12039] ? __pfx_bch2_latency_acct
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/io_write.c:66)
> [88.498248][T12039] bch2_btree_node_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1748)
> [88.498921][T12039] ? __pfx_bch2_btree_node_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1685)
> [88.499664][T12039] ? find_held_lock
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5341)
> [88.500290][T12039] ? __pfx_lock_release
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5859)
> [88.500940][T12039] ? __bch2_trans_unlock
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_iter.h:111
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_locking.c:725)
> [88.501616][T12039] ? __pfx_bch2_btree_cache_cmp_fn
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_cache.c:135)
> [88.502392][T12039] bch2_btree_root_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/instrumented.h:68
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/asm-generic/bitops/instrumented-non-atomic.h:141
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_types.h:628
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1791
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1811)
> [88.503064][T12039] ? __pfx___mutex_unlock_slowpath
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/mutex.c:885)
> [88.503849][T12039] ? __pfx_bch2_btree_root_read
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/btree_io.c:1810)
> [88.504562][T12039] bch2_fs_recovery
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:581
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:928)
> [88.505228][T12039] ? __pfx_bch2_fs_recovery
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/recovery.c:699)
> [88.505862][T12039] ? bch2_get_next_online_dev
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:347
> /data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/rcupdate.h:880
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/sb-members.h:157)
> [88.506608][T12039] ? __pfx_lock_release
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5859)
> [88.507271][T12039] ? bch2_get_next_online_dev
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/sb-members.h:160)
> [88.508010][T12039] ? llist_reverse_order
> (/data/ghui/docker_data/linux_kernel/upstream/linux/lib/llist.c:115)
> [88.508649][T12039] ? __closure_wake_up
> (/data/ghui/docker_data/linux_kernel/upstream/linux/lib/closure.c:89)
> [88.509258][T12039] bch2_fs_start
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/super.c:1041)
> [88.509806][T12039] bch2_fs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2204)
> [88.510403][T12039] ? __pfx_bch2_fs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/bcachefs/fs.c:2160)
> [88.511023][T12039] ? lock_acquire
> (/data/ghui/docker_data/linux_kernel/upstream/linux/kernel/locking/lockdep.c:5824)
> [88.511565][T12039] ? rcu_is_watching
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/context_tracking.h:128
> /data/ghui/docker_data/linux_kernel/upstream/linux/kernel/rcu/tree.c:716)
> [88.512125][T12039] ? bpf_lsm_capable
> (/data/ghui/docker_data/linux_kernel/upstream/linux/./include/linux/lsm_hook_defs.h:44)
> [88.512683][T12039] ? security_capable
> (/data/ghui/docker_data/linux_kernel/upstream/linux/security/security.c:1143
> (discriminator 120))
> [88.513382][T12039] vfs_get_tree
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/super.c:1815)
> [88.513927][T12039] path_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3561
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3887)
> [88.514518][T12039] ? kmem_cache_free
> (/data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4609
> /data/ghui/docker_data/linux_kernel/upstream/linux/mm/slub.c:4711)
> [88.515169][T12039] ? __pfx_path_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3814)
> [88.515828][T12039] ? putname.part.0
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namei.c:297)
> [88.516481][T12039] __x64_sys_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:3901
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4111
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088
> /data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088)
> [88.517116][T12039] ? __pfx___x64_sys_mount
> (/data/ghui/docker_data/linux_kernel/upstream/linux/fs/namespace.c:4088)
> [88.517828][T12039] do_syscall_64
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/common.c:52
> /data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/common.c:83)
> [88.518441][T12039] entry_SYSCALL_64_after_hwframe
> (/data/ghui/docker_data/linux_kernel/upstream/linux/arch/x86/entry/entry_64.S:130)
> [ 88.519229][T12039] RIP: 0033:0x7f7c16f9e49e
> [ 88.519814][T12039] Code: 48 c7 c0 ff ff ff ff eb aa e8 5e 20 00 00
> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f 1e fa 49 89 ca b8 a5
> 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8
> 64 89 01 48
> All code
> ========
> 0: 48 c7 c0 ff ff ff ff mov $0xffffffffffffffff,%rax
> 7: eb aa jmp 0xffffffffffffffb3
> 9: e8 5e 20 00 00 call 0x206c
> e: 66 2e 0f 1f 84 00 00 cs nopw 0x0(%rax,%rax,1)
> 15: 00 00 00
> 18: 0f 1f 40 00 nopl 0x0(%rax)
> 1c: f3 0f 1e fa endbr64
> 20: 49 89 ca mov %rcx,%r10
> 23: b8 a5 00 00 00 mov $0xa5,%eax
> 28: 0f 05 syscall
> 2a:* 48 3d 01 f0 ff ff cmp $0xfffffffffffff001,%rax <-- trapping instruction
> 30: 73 01 jae 0x33
> 32: c3 ret
> 33: 48 c7 c1 a8 ff ff ff mov $0xffffffffffffffa8,%rcx
> 3a: f7 d8 neg %eax
> 3c: 64 89 01 mov %eax,%fs:(%rcx)
> 3f: 48 rex.W
> 
> Code starting with the faulting instruction
> ===========================================
> 0: 48 3d 01 f0 ff ff cmp $0xfffffffffffff001,%rax
> 6: 73 01 jae 0x9
> 8: c3 ret
> 9: 48 c7 c1 a8 ff ff ff mov $0xffffffffffffffa8,%rcx
> 10: f7 d8 neg %eax
> 12: 64 89 01 mov %eax,%fs:(%rcx)
> 15: 48 rex.W
> [ 88.522326][T12039] RSP: 002b:00007f7c17ce4da8 EFLAGS: 00000246
> ORIG_RAX: 00000000000000a5
> [ 88.523371][T12039] RAX: ffffffffffffffda RBX: 00000000000119f4 RCX:
> 00007f7c16f9e49e
> [ 88.524293][T12039] RDX: 0000000020011a00 RSI: 0000000020000000 RDI:
> 00007f7c17ce4e00
> [ 88.525203][T12039] RBP: 00007f7c17ce4e40 R08: 00007f7c17ce4e40 R09:
> 0000000000000000
> [ 88.526106][T12039] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000020011a00
> [ 88.527079][T12039] R13: 0000000020000000 R14: 00007f7c17ce4e00 R15:
> 0000000020000100
> [ 88.528111][T12039] </TASK>
> [ 88.528793][T12039] Kernel Offset: disabled
> [ 88.529305][T12039] Rebooting in 86400 seconds..
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/CAHOo4gLWAbArwg%2Bw%2BAqqkxGmOFX6cm8Tvy85tb4igN6V7Z9BZQ%40mail.gmail.com.
