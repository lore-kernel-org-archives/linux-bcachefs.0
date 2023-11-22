Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ToypDvhU"
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [IPv6:2001:41d0:1004:224b::bc])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA351AB
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Nov 2023 14:42:14 -0800 (PST)
Date: Wed, 22 Nov 2023 17:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1700692932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=S5RIBgmlMLqW8rTznyMYInPN5NtJWFJGVUiISZ95zro=;
	b=ToypDvhU3RybpuFWldIzS7/VZZGntIItdAxeG8dIJApgf3grYgaGb7ggbkJ2hiruX5Db70
	hooqi+sO0+Vgfcmr/HFe4kHDPLatHjT6svb6trCGZnkqnGvBdeMeXS3B4qgQ5NugFHp4RL
	mfEmmWoeUdj7J8g/96KUx77q8sUwKnw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@fb.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: zstd error when used in bcachefs
Message-ID: <20231122224208.procyauioksotuit@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Migadu-Flow: FLOW_OUT

I just got a report of data being marked as incompressible when written
with particular blocksizes.

Investigating a bit further, when attempting to compress >= 32k (of all
zeroes), I get:
[    8.214090] bcachefs (vdb): zstd error: (efault) -64, src_len 32768 dst_len 32768
[    8.214713] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
[    8.215349] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
[    8.215432] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536

bcachefs code that calls zstd:
https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/compress.c?h=bcachefs-testing#n350

-64 appears to be ZSTD_error_memory_allocation, but I get no hits for
that grepping, so I'm a bit stuck.
