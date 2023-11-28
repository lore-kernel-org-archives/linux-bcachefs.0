Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PTmyD4/r"
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [IPv6:2001:41d0:1004:224b::aa])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE0BE1
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 Nov 2023 14:17:29 -0800 (PST)
Date: Tue, 28 Nov 2023 17:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701209847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqNZK0/jmaprhVzOYAKaups2Nf4NOS70ZW2SfZ/JkSs=;
	b=PTmyD4/rBBPIccuTjsVP2zbqAKTtxfE5wF01LBetAuKGDzsXURatkcvN9CoB8nSFaa0hAy
	JrNzHAfiPcJ5X6DKK3ToVp0Bx+eqnGrbl6zuOMR8sDT7m75f8rYBD5dX9DpiC51avk2mAf
	m3q3UXIhJcfGuct/P4BmjCQ0iQziSrg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nick Terrell <terrelln@meta.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	Nick Terrell <nickrterrell@gmail.com>
Subject: Re: zstd error when used in bcachefs
Message-ID: <20231128221725.azdtxuuculk7tqu4@moria.home.lan>
References: <20231122224208.procyauioksotuit@moria.home.lan>
 <93FB4B05-7C53-4771-A4CF-1D21AB837726@meta.com>
 <20231128021820.bc4ec62ynhtbtihh@moria.home.lan>
 <31B4E7FB-A79A-4FEB-BB75-37FE54D83636@meta.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31B4E7FB-A79A-4FEB-BB75-37FE54D83636@meta.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 09:36:56PM +0000, Nick Terrell wrote:
> 
> 
> > On Nov 27, 2023, at 6:18 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  This Message Is From an External Sender
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Mon, Nov 27, 2023 at 07:52:04PM +0000, Nick Terrell wrote:
> >> 
> >> 
> >>> On Nov 22, 2023, at 5:42 PM, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >>> 
> >>> ﻿!-------------------------------------------------------------------|
> >>> This Message Is From an External Sender
> >>> 
> >>> |-------------------------------------------------------------------!
> >>> 
> >>> I just got a report of data being marked as incompressible when written
> >>> with particular blocksizes.
> >> 
> >> Is this on linux-next? If not, which revision?
> >> 
> >>> Investigating a bit further, when attempting to compress >= 32k (of all
> >>> zeroes), I get:
> >>> [    8.214090] bcachefs (vdb): zstd error: (efault) -64, src_len 32768 dst_len 32768
> >>> [    8.214713] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
> >>> [    8.215349] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
> >>> [    8.215432] bcachefs (vdb): zstd error: (efault) -64, src_len 65536 dst_len 65536
> >>> 
> >>> bcachefs code that calls zstd:
> >>> https://evilpiepirate.org/git/bcachefs.git/tree/fs/bcachefs/compress.c?h=bcachefs-testing#n350 
> >> 
> >> I’ll look into this tomorrow when I get back to my computer.
> >> 
> >>> -64 appears to be ZSTD_error_memory_allocation, but I get no hits for
> >>> that grepping, so I'm a bit stuck.
> > 
> > It appears that the workspace size given by zstd_cctx_workspace_bound()
> > is wrong - if I double the workspace size it works.
> > 
> > I traced it to the workspaceTooSmall check in zstd_compress.c.
> 
> Hi Kent,
> 
> It looks like there was a bug in how bcachefs called zstd that triggered this error.
> I’m looking at the code at the tag v6.7-rc3.
> 
> In the function __bch2_fs_compress_init I see this [0]:
> 
> 	ZSTD_parameters params = zstd_get_params(zstd_max_clevel(), c->opts.encoded_extent_max);
> 	// …
> 	c->zstd_params = params;
> 
> Then later in attempt_compress I see this [1]:
> 
> 	unsigned level = min((compression.level * 3) / 2, zstd_max_clevel());
> 	ZSTD_parameters params = zstd_get_params(level, c->opts.encoded_extent_max);
> 	ZSTD_CCtx *ctx = zstd_init_cctx(workspace, zstd_cctx_workspace_bound(&params.cParams));
> 	size_t len = zstd_compress_cctx(ctx, dst + 4, dst_len - 4 - 7, src, src_len, &c->zstd_params);
> 
> The workspace is initialized correctly, in that it is sized for the maximum possible level.
> However, zstd_init_cctx() is called with a workspace that is sized using the level chosen by
> compression.level, so It only believes that it has that much memory available. Then
> zstd_compress_cctx is called with &c->zstd_params, which are the params for the maximum
> level, which needs more memory than Zstd was told is available.
> 
> The fix is to call zstd_compress_cctx with &params instead of &c->zstd_params. You shouldn’t need
> to store the zstd_params in the bch_fs struct after that.

You're right - the workspace sizes were swapped.

Sorry for the fake bug report :)
