Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E5D38C
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jul 2024 00:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722387177; cv=none; b=ZqePbpS2dXQBqj5367udj5cDZIQ39gwSnZpJ2Jw0XOgBAs2gx+xs2cTVQS1c7hpOVkEI8n/S+yba8q2owwq5nbpMI6C36GotGXIYrCAWDgd0kQyt+A/s4C7xigDurx+5wbTg2CK1lPZnKewnfd25zuYVowBgKCaezaeyW7DNiEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722387177; c=relaxed/simple;
	bh=RFzBDEACN54BlktdwPVLsaXYKHqevn8Ah3qOD6p3lVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWVpYs8cr0MtTRERYFIiRZCHjaCJM86D+yErtsWdcoVmTVE0hwW1HvjaWlSawsq877lCIicEw9Re9Gx6wDnYELV7edmbs4enQdpAb9U/FVH02yKfCx9LsoTnX0uJ2U0u7N+rJc/TBL7AM/mKYBwMF2sLmXDXSguDtJBK+NILJ3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cPT8PPFu; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cPT8PPFu"
Date: Tue, 30 Jul 2024 20:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1722387172;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QdOSEkeUenRtcbHdw9g4dXOoiO0ucmftbM8CCNfxNnE=;
	b=cPT8PPFuUL/funWQ6votzxwr0H5FXftlOS+Uv2sTnM0jARnERS8SgUFIqDTICep4theyTS
	jKsB9vIPE9/Gr6+7rPNExFF924QL2KWQAZ9Hey1WpD2DGuSfqad9jch9ehtHnYR6QYgEqm
	EXlSDOlkBJM2av5R7kx86ypnbbXotDg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: Add checks for entry's _data bytes
Message-ID: <apj4zcnnq5nwcly4mnl76uiuwibkzayqd3beeum3p436kycksf@co4yrhzxo7kl>
References: <000000000000b2c0fc061e6cb26b@google.com>
 <tencent_3D4E4FB18DDDA5988DE9920ADDDFDD859907@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_3D4E4FB18DDDA5988DE9920ADDDFDD859907@qq.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jul 30, 2024 at 12:10:19PM GMT, Edward Adam Davis wrote:
> syzbot report slab-out-of-bounds in journal_entry_dev_usage_to_text,
> it because vstruct_bytes(entry) smaller than sizeof(struct 
> jset_entry_dev_usage), overflow occurs when calculating the difference in
> jset_entry_dev_usage_nr_types(u).
> 
> Reported-by: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=05d7520be047c9be86e0
> Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> ---
>  fs/bcachefs/sb-clean.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/sb-clean.c b/fs/bcachefs/sb-clean.c
> index 47f10ab57f40..278e1a25159a 100644
> --- a/fs/bcachefs/sb-clean.c
> +++ b/fs/bcachefs/sb-clean.c
> @@ -310,6 +310,9 @@ static void bch2_sb_clean_to_text(struct printbuf *out, struct bch_sb *sb,
>  		    !entry->u64s)
>  			continue;
>  
> +		if (vstruct_bytes(entry) < sizeof(struct jset_entry_dev_usage))
> +			continue;

This is wrong: you haven't checked the entry type and you're assuming
it's a dev_usage entry.

The check should go in journal_entry_dev_usage_to_text().
