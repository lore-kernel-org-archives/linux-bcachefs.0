Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A5D13AF2
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Oct 2024 03:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728270358; cv=none; b=hNdt/GjMBraaNc/StmUIWUAdnHQmtFYZsnVdt8xmBhWF7MspyzfSd1OkRyzqBPzqlUD/A9i210quOtBp2lcKtuyZ/sCkO0VjaHwjZE5d/7iK3iJ+iGTDOwZE9KzZ2AOuxzNvvDOy9qIZI4+JjOGG/9zrdQOe9ZNhIugu+ikYkaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728270358; c=relaxed/simple;
	bh=T/ddEH7TNtOZLM3S6LlNm+FjYYEfRrVebNssludRJVk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AUy781k7vR520viQGXQsi/XtSOc04GTcPjHuDXlhM/r/Av48BaLCz4BWggNIdA6bP3jCZjibDFGfsHK1ETQFVBvLsCt4FVt6fdvnH0/qdvNxXk3WVfxa5j7kPXZp6FDUhTv3HEv14TDzhwJjcPE+XwN/VUGlHGCqlg6AtOJ41Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BITiCUhW; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BITiCUhW"
Date: Sun, 6 Oct 2024 23:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728270354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LZskce4zQSmL2x55KK1UXq6rkByUV73hGtyXwEDqQiI=;
	b=BITiCUhWOQcAtqafqVzLv7kf0TUFzBu/zkUbFn/eP16+06cLJNNFDe/c15lDeckPmXDMiK
	vlXmm6anFWJ5bmZbWvZQI6Df3zkVWaiLc9jPAEHFhOq4YJrwIGERsgB+NZ2+mAkdgl5lG/
	XNEFIUOdjMSSZF/tU15FLiIG9mCzsuA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+cf7b2215b5d70600ec00@syzkaller.appspotmail.com
Subject: Re: [PATCH v1] bcachefs: add check for btree id against max in try
 read node
Message-ID: <lxq42z72rrcoqmcj6z4rvesjvxoxf3q7dss666pjyzao4gaftt@tiayr4siis3z>
References: <20240929142348.4028284-2-pZ010001011111@proton.me>
 <O4rJH-M2oslervXHx_G8BgaihhTfNDOLBvBL3_-k-xQ5v3RLnZ1m8WfhBENbliRTjeQV-22K7tqvKJzgLNeV2A72qKLNmFl5KBa_Y65unyo=@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <O4rJH-M2oslervXHx_G8BgaihhTfNDOLBvBL3_-k-xQ5v3RLnZ1m8WfhBENbliRTjeQV-22K7tqvKJzgLNeV2A72qKLNmFl5KBa_Y65unyo=@proton.me>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 07, 2024 at 02:53:13AM GMT, Piotr Zalewski wrote:
> > Add check for read node's btree_id against BTREE_ID_NR_MAX in
> > try_read_btree_node to prevent triggering EBUG_ON condition in
> > bch2_btree_id_root[1].
> 
> There seems to be some kind of (pro)regression regarding this issue. Now it
> triggers a deadlock. I also found related bug detected by syzbot[2] for
> which someone supplied the same patch recently and it triggered the same
> deadlock. I will look into it (perhaps simple check isn't a proper fix 
> here).
> 
> > [1] https://syzkaller.appspot.com/bug?extid=cf7b2215b5d70600ec00
> 
> [2] https://syzkaller.appspot.com/bug?extid=9f41e4b255897d99d4e9

Your patch looks correct, [2] shouldn't be possible with it - and it
appears to only be reported on upstream commits. I'll apply your patch.
