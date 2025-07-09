Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DEC22E40F
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Jul 2025 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.30.212.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752081843; cv=none; b=FbT5kXVEHYwcvG1M8+PwEApfAYOpE2rYo+6y5yVsNMobYEhHziKEULWsvPCQZl4lSsr+Hs78WRJEpcCClGl4+aWrV877VbBlTB9DZ0/fFIGP96est1nzgPpsGK3l4K4T0oaXhVfwsMYuNX9W509U5bh8O/uc0VuIpAucRDxbVak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752081843; c=relaxed/simple;
	bh=PJKZsoBhMARtNFs/BgxnO71T9vGUHAGD0k6HVrVMEWU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HDiNMIbREVUxKQe4r9Rt61gGCavhb+LBqeKvLuQTeM0aA4zzR3hjMtnRjxctGL9LOqB8fV8JUWKF5YuD86gf6rVeHLz0o6YGs2By7QQFc+fDg43T87lRH9CW9iAbbPebhMju/ruxNzT3w7sWo2aEkobfS7cnrv141+EuQ8NMqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.se; spf=none smtp.mailfrom=konsulko.se; dkim=pass (2048-bit key) header.d=konsulko.se header.i=@konsulko.se header.b=P3OX390J; dkim=permerror (0-bit key) header.d=konsulko.se header.i=@konsulko.se header.b=nqZBr7WA; arc=none smtp.client-ip=46.30.212.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=konsulko.se
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=konsulko.se
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=konsulko.se header.i=@konsulko.se header.b="P3OX390J";
	dkim=permerror (0-bit key) header.d=konsulko.se header.i=@konsulko.se header.b="nqZBr7WA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1752081837; x=1752686637;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=d2SNgT3zWT55ZJonvlVnvWUHIgX1usEw9kq+taiSSKY=;
	b=P3OX390JooMl+DEl4Mh9eK38swP8Yrm2WpcYekSqBZDwb1QoQz/LJsoaJj0c2IusZG8KuIbB87vm0
	 4PIna415shUAZ/FyjW9+/14uwmqq3F4QaTE2OFwrvDjJjAc8N3Zqb7DrkV0X6viQV6i1t+yxddibzP
	 EzVM6lvovwIG36fSlaDjrAKDJkaawJDLXc51RGBQhbLKY7FIzjn95vYvPtaBy0gUH+azh4W0nRYpy/
	 /rsNP5dEJ7Sl6FFYpcmqWFYPJ3f30GgcIZ6T4qNboZWNF9cfpTdQhbXtfOaDNZ6tPK6MuX34eeV4K9
	 p5AKb9ar2TfO/JLcR2SOSpt0MmWnaSw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1752081837; x=1752686637;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=d2SNgT3zWT55ZJonvlVnvWUHIgX1usEw9kq+taiSSKY=;
	b=nqZBr7WAf1BvRYtwCoEEGNAW8eYSiFLnd/ymCMW/6WJFNO9I1NKqNP0ctD6KmRsm9r1fovKdgQB4M
	 zqPgxtuCA==
X-HalOne-ID: 7cda66ea-5ce9-11f0-807a-fb5fec76084d
Received: from slottsdator.home (host-90-238-19-233.mobileonline.telia.com [90.238.19.233])
	by mailrelay3.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 7cda66ea-5ce9-11f0-807a-fb5fec76084d;
	Wed, 09 Jul 2025 17:23:56 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	rust-for-linux@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	bpf@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH v12 0/4] support large align and nid in Rust allocators
Date: Wed,  9 Jul 2025 19:23:45 +0200
Message-Id: <20250709172345.1031907-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The coming patches provide the ability for Rust allocators to set
NUMA node and large alignment.

Changelog:
v2 -> v3:
* fixed the build breakage for non-MMU configs
v3 -> v4:
* added NUMA node support for k[v]realloc (patch #2)
* removed extra logic in Rust helpers
* patch for Rust allocators split into 2 (align: patch #3 and
  NUMA ids: patch #4)
v4 -> v5:
* reworked NUMA node support for k[v]realloc for all 3 <alloc>_node
  functions to have the same signature
* all 3 <alloc>_node slab/vmalloc functions now support alignment
  specification
* Rust helpers are extended with new functions, the old ones are left
  intact
* Rust support for NUMA nodes comes first now (as patch #3)
v5 -> v6:
* added <alloc>_node_align functions to keep the existing interfaces
  intact
* clearer separation for Rust support of MUNA ids and large alignments
v6 -> v7:
* NUMA identifier as a new Rust type (NumaNode)
* better documentation for changed and new functions and constants
v7 -> v8:
* removed NumaError
* small cleanups per reviewers' comments
v8 -> v9:
* realloc functions can now reallocate memory for a different NUMA
  node
* better comments/explanations in the Rust part
v9 -> v10:
* refined behavior when memory is being reallocated for a different
  NUMA node, comments added
* cleanups in the Rust part, rustfmt ran
* typos corrected
v10 -> v11:
* added documentation for the NO_NODE constant
* added node parameter to Allocator's alloc/realloc instead of adding
  separate alloc_node resp. realloc_node functions, modified users of
  alloc/realloc in accordance with that
v11 -> v12:
* some redundant _noprof functions removed in patch 2/4
* c'n'p error fixed in patch 2/4 (vmalloc_to_page -> virt_to_page)
* some typo corrections and documentation updates, primarily in patch
  3/4

Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
