Received: from mail-108-mta74.mxroute.com (mail-108-mta74.mxroute.com [136.175.108.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414CF4085E
	for <linux-bcachefs@vger.kernel.org>; Sat,  9 Mar 2024 16:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710000867; cv=none; b=hq8NwzPmR0XjWyqC9eWWESzltY841+WUULbCmm+FRNITw75RJ+/kX5EpddfDRHEpHAQRBkpzJp7QS/EOJfq0M8nXNitrjWp1iq2/IeyBH5T7ydhlfJ389PZiq3+gdeeMr2Q86xJUS2RWnttIZ/t6jaWY1Yc8jXMmrc6fCU5mhkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710000867; c=relaxed/simple;
	bh=UW44JSvdGY6Ke/M8/rgso5bX2pK59NzVFZ0hQKD1fgA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JjaTGb0eA4fRKTKbsKevRS5lx+cJO35IlZBS1cgxG9BlSPaU6gKG0eFjXO/Htg5knfJLIRXrQcjtdFkwF4zfkeuZXzTahwk+MEWpKomvJwi+1aqrFuG7DL+FST6xRW6o1j7tWQ/epwPWv4YVio6u1+Rpbn+BhTImf01yylqbzwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e.netreq.com; spf=pass smtp.mailfrom=e.netreq.com; dkim=temperror (0-bit key) header.d=e.netreq.com header.i=@e.netreq.com header.b=QpvnNPza; arc=none smtp.client-ip=136.175.108.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=e.netreq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=e.netreq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=e.netreq.com header.i=@e.netreq.com header.b="QpvnNPza"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta74.mxroute.com (ZoneMTA) with ESMTPSA id 18e23f9b2170003bea.001
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sat, 09 Mar 2024 16:09:10 +0000
X-Zone-Loop: 7d103ef296cae7e80b9420f09f035c65d8a27ba33d01
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=e.netreq.com; s=x; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:
	Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BOxngd0GONQPHRcqrWztqNsXcCEgTXQ2skK4TFsBeGY=; b=QpvnNPzaGV7Jx4OBqYaUIVI0+5
	G3mbvfFXACs4Q+wlI19SwaZvQpeIUvMu5VVU/fOH57hTgM/SGpi8lP3PFKuc4eIC4UwGq5G3Q7aAS
	Ip9QS+hI4bHSeEmUyM0SwsC3gJpemwHcjVZY4v3bnly1YNDT7rGwXxP6rUPwfZokJ7SR3+ha6RDTc
	VCVX8qG1UE0SHaAQFVn5bRhywf/JkjPM+n2BIQ5/n2MibcEQN6oCS5nlIl1mZCU8vJ3Oy1qxInQK8
	cZuL7tqJlOQWqXRTs9pMO/VuyVX53aKi0BRIku7+EF4ONI/6r3SPcVIlSIQTUtoRh7rc9ZpfXqh84
	RlGqckQQ==;
Date: Sat, 9 Mar 2024 11:09:07 -0500
From: Alec Moskvin <list.bcachefs@e.netreq.com>
To: linux-bcachefs@vger.kernel.org
Subject: Kernel WARNING in get_page_from_freelist on Linux 6.7.9
Message-ID: <20240309160907.GA3229@haswell>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/2.2.12 (2023-09-09)
X-Authenticated-Id: alec@netreq.com

Hello,

I'm getting the warning below when linking with the mold linker on 
bcachefs. It's very reproducible, and seems to always be triggered by 
ld.mold.

Please let me know if you need any additional info.

Thanks,
Alec

[  237.959266] ------------[ cut here ]------------
[  237.959272] WARNING: CPU: 6 PID: 2346 at mm/page_alloc.c:2897 get_page_from_freelist+0x916/0xc40
[  237.959285] CPU: 6 PID: 2346 Comm: ld.mold Not tainted 6.7.9 #164
[  237.959289] Hardware name: Gigabyte Technology Co., Ltd. H97-D3H/H97-D3H-CF, BIOS F6 04/21/2015
[  237.959292] RIP: 0010:get_page_from_freelist+0x916/0xc40
[  237.959308] Code: 0f 84 a0 fc ff ff 48 8b 44 24 08 f7 44 24 54 00 80 00 00 8b 40 18 89 44 24 24 0f 84 47 f8 ff ff 41 83 ff 01 0f 86 a3 fa ff ff <0f> 0b e9 36 f8 ff ff 44 89 ee e8 eb 4c fc ff 48 89 44 24 18 e9 8d
[  237.959312] RSP: 0000:ffffb9a3cd197aa0 EFLAGS: 00010202
[  237.959315] RAX: 0000000000000000 RBX: 0000000000000901 RCX: 0000000000000003
[  237.959317] RDX: 0000000000000001 RSI: ffffffffa29ccbd8 RDI: ffffffffa29cca40
[  237.959320] RBP: 3e000000007fffff R08: 0000000000000000 R09: ffffe3fb453f2c08
[  237.959322] R10: 0000000000000002 R11: 0000000000000000 R12: 00000000006656a8
[  237.959323] R13: 0000000000000002 R14: ffffffffa29cca40 R15: 0000000000000003
[  237.959325] FS:  00007f42e08c4780(0000) GS:ffffa1a97dd80000(0000) knlGS:0000000000000000
[  237.959328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  237.959330] CR2: 00007f42d7f6e007 CR3: 000000017b250002 CR4: 00000000001706f0
[  237.959332] Call Trace:
[  237.959336]  <TASK>
[  237.959338]  ? __warn+0x66/0xc0
[  237.959344]  ? get_page_from_freelist+0x916/0xc40
[  237.959347]  ? report_bug+0x166/0x1b0
[  237.959363]  ? handle_bug+0x3c/0x70
[  237.959371]  ? exc_invalid_op+0x17/0x70
[  237.959375]  ? asm_exc_invalid_op+0x1a/0x20
[  237.959383]  ? get_page_from_freelist+0x916/0xc40
[  237.959386]  ? xas_alloc+0xa4/0xc0
[  237.959390]  ? filemap_get_entry+0x62/0x120
[  237.959395]  __alloc_pages+0x158/0x240
[  237.959397]  __kmalloc_large_node+0x73/0x150
[  237.959400]  __bch2_folio_create+0x34/0x60
[  237.959404]  bch2_readahead+0x11f/0x320
[  237.959407]  read_pages+0x53/0x220
[  237.959410]  page_cache_ra_order+0x1e7/0x320
[  237.959421]  filemap_fault+0x781/0xa10
[  237.959424]  bch2_page_fault+0x159/0x1e0
[  237.959427]  __do_fault+0x2c/0xb0
[  237.959430]  __handle_mm_fault+0xb5f/0x10f0
[  237.959434]  handle_mm_fault+0x186/0x370
[  237.959438]  exc_page_fault+0x15c/0x5c0
[  237.959440]  asm_exc_page_fault+0x26/0x30
[  237.959444] RIP: 0033:0x563215944978
[  237.959446] Code: 00 00 41 55 c5 f9 ef c0 41 54 55 48 89 f5 53 48 83 ec 08 0f b7 05 ca e6 9d ff 48 8b 5f 30 bf 3e 00 00 00 48 03 9e 28 0d 00 00 <c5> fa 7f 43 07 c5 fa 7f 43 17 c5 fa 7f 43 27 c7 03 7f 45 4c 46 66
[  237.959449] RSP: 002b:00007fff71495510 EFLAGS: 00010206
[  237.959452] RAX: 0000000000000102 RBX: 00007f42d7f6e000 RCX: 0000000000000020
[  237.959454] RDX: 00000200001614a0 RSI: 00007fff71495fb0 RDI: 000000000000003e
[  237.959455] RBP: 00007fff71495fb0 R08: 00007fff7150f080 R09: 0000000000000001
[  237.959457] R10: 0000000000000000 R11: 000000000000000a R12: 00007fff714959e0
[  237.959459] R13: 00007fff71495610 R14: 00007f42e05e6a00 R15: 0000000000000000
[  237.959461]  </TASK>
[  237.959462] ---[ end trace 0000000000000000 ]---
