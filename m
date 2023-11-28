Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xLGVAY5F"
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF87F1A3
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Nov 2023 18:18:25 -0800 (PST)
Date: Mon, 27 Nov 2023 21:18:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701137903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLu6qZ1uBAVMGJFsam48U2rvDk8gBFqqO3KWz6gigsI=;
	b=xLGVAY5F6n5MsVo17LK/KXes3JbOBqU9uIbzFyGrWo84tlVcXX9ACVgqAHw0IJ1FfaBia+
	cooV1Ut7elCPxmK3JK8+LPgxC3QGCsyIginZ6taiVSGwnrlZ8vuFFdItH8lsddNONpTjGF
	XzxelYDmX4d3Wf6ySzIgyZW7otm5Mso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@meta.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	Nick Terrell <nickrterrell@gmail.com>
Subject: Re: zstd error when used in bcachefs
Message-ID: <20231128021820.bc4ec62ynhtbtihh@moria.home.lan>
References: <20231122224208.procyauioksotuit@moria.home.lan>
 <93FB4B05-7C53-4771-A4CF-1D21AB837726@meta.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93FB4B05-7C53-4771-A4CF-1D21AB837726@meta.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Nov 27, 2023 at 07:52:04PM +0000, Nick Terrell wrote:
> 
> 
> > On Nov 22, 2023, at 5:42 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > ﻿!-------------------------------------------------------------------|
> >  This Message Is From an External Sender
> > 
> > |-------------------------------------------------------------------!
> > 
> > I just got a report of data being marked as incompressible when written
> > with particular blocksizes.
> 
> Is this on linux-next? If not, which revision?
> 
> > Investigating a bit further, when attempting to compress >= 32k (of all
> > zeroes), I get:
> > [    8.214090] bcachefs (vdb): zstd error: (efault) -64, src_len 32768 dst_len 32768
> > [    8.214713] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
> > [    8.215349] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
> > [    8.215432] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
> > 
> > bcachefs code that calls zstd:
> > https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/compress.c?h=bcachefs-testing#n350
> 
> I’ll look into this tomorrow when I get back to my computer.
> 
> > -64 appears to be ZSTD_error_memory_allocation, but I get no hits for
> > that grepping, so I'm a bit stuck.

It appears that the workspace size given by zstd_cctx_workspace_bound()
is wrong - if I double the workspace size it works.

I traced it to the workspaceTooSmall check in zstd_compress.c.
