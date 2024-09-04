Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0C284A27
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 19:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478784; cv=none; b=QDYtxtSc+Ytm11X6ROu8S+c9a3CNJ/yNWJI7Rmm5CWLjQqwbv/U6ulgVVr9jkao5sMMVznOLOqVwIL11g8dBQZx7AWf4Wkh59sx0hgB9Q+oJvmXi+u0zkxLSGM3hOQAghh0hrrmYRXh7xKpZV1Y6g1CvozD8doT8fec40K77k48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478784; c=relaxed/simple;
	bh=Yb/E+J+/esr8u42OuIfGkgTyVW9WUZnN2EVrLKZt8pI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ByBGAv7U6hrMFGXIbUOVXUYo/UMMQVVPMxVh/KdBINRjb3c2HStw6iAe4d9JkODALCfl8QXZ03BSMKXajs4KiN5F35fVJt9NLKQuyH7RzQmithF6Fj3mAjsJabMVorF6zbT+5oSmIPXkASAhsj3gzN23wA4UfGnzWgAAANE9Mu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KapLDVsy; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KapLDVsy"
Date: Wed, 4 Sep 2024 15:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725478780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IAe0DsjfS098LTlrXGBxc7ZFT5ujdMHD3fVRDFmSe5M=;
	b=KapLDVsyqBJ3EAR9fSk1od3o4xIRz7Om8YBYGDmzvrUYOu7rVf5y9qNCeqOOY7N5cOxVFK
	rs2jGWEnIrgP7ZigWj24nm/TBrIXMq+E8XgnU7mmDSuzawWQKeVEMRq4M2kdOX3wxJZKwp
	5C0CNf5xeVFoPhMwBZQZPBdqynD1o3Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+064ce437a1ad63d3f6ef@syzkaller.appspotmail.com, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in member_to_text
Message-ID: <hqzhbzxbp3rjbal3z4kdwygvus76h22o2br3iwuzohgniivw5q@etyntoz75vyp>
References: <00000000000005e6c90621278371@google.com>
 <tencent_6ECC3C5D37B696EC36DE4A4C759B770B6709@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_6ECC3C5D37B696EC36DE4A4C759B770B6709@qq.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 03, 2024 at 10:13:02AM GMT, Edward Adam Davis wrote:
> Because the value of m.btree_bitmap_shift is 69 in this case, it cause 
> shift-out-of-bounds in member_to_text.
> 
> Add a check for btree_bitmap_shift in validate_member, when it bigger than 64
> return -BCH_ERR_invalid_sb_members.
> Simultaneously adjust the output mode of btree_bitmap_shift in member_to_text. 
> 
> #syz test
> 
> diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
> index 39196f2a4197..85a4245ea6a3 100644
> --- a/fs/bcachefs/sb-members.c
> +++ b/fs/bcachefs/sb-members.c
> @@ -162,6 +162,12 @@ static int validate_member(struct printbuf *err,
>  		return -BCH_ERR_invalid_sb_members;
>  	}
>  
> +	if (m.btree_bitmap_shift > 64) {

should be >=, no?

> +		prt_printf(err, "device %u: too many big bitmap shift (got %u, max 64)",
> +			   i, m.btree_bitmap_shift);
> +		return -BCH_ERR_invalid_sb_members;
> +	}
> +
>  	return 0;
>  }
>  
> @@ -245,8 +251,7 @@ static void member_to_text(struct printbuf *out,
>  		prt_printf(out, "(none)");
>  	prt_newline(out);
>  
> -	prt_printf(out, "Btree allocated bitmap blocksize:\t");
> -	prt_units_u64(out, 1ULL << m.btree_bitmap_shift);
> +	prt_printf(out, "Btree allocated bitmap shift: %d\t", m.btree_bitmap_shift);
>  	prt_newline(out);
>  
>  	prt_printf(out, "Btree allocated bitmap:\t");
> 
