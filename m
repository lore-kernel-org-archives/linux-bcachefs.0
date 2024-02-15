Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1075512E1C7
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 18:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708020148; cv=none; b=VRmFdbxIblIjyX08w/b3q7+l6ubl6Vm2pP+AkWjZC9LOKtIaP2j3teTXu+j3b1HMQfIBbmZ6ynvgwYjmQLHFTzxyt5FaYQiJs4xbeY/TWMINs3qe1gRxaI2M2tIiWIXTSUzyrV8CjcLT8PZNhiEqOcSbTh1Eq6gt1UdmZNxoV+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708020148; c=relaxed/simple;
	bh=TpgPFN8FSuIp5ywEmQL9dZ8GlQm+E8gugpWkDVv6bqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQ/R+dgZtJaragG3OSodoGxpDLZJZfxV1a8CQugfGDZpHIGY61qp+VHdNCQ8bpwW6NfNcOzyHmSPI3rd/wGGSthlGiGPpbgVlz01TT2s9X1vusD8CXjv8UCm4hLHz8eBesrqg0aJdVtXoLTzSmcUZXdUr3v5/LObk5C+5JpePfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=faV/NqwJ; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="faV/NqwJ"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-363b6848f95so4538005ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 10:02:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708020145; x=1708624945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RTLhguGP2E+1eVlfyjhu3om+JFr1gOZVx4tF8A8nZOg=;
        b=faV/NqwJOowX20ZsdkG28Lf/vyLRmZe/qVNp8pilB/vc/QXlJlt89odRXT4x4rd4In
         qmeUEFtG8azzAuBZzbKf7rSjxA7V9TrU7d1LVhGwAd3P1vb+AUauwPO5RMFwSsYMLp4Z
         2Mdg599BV84CWVCp9LWawZVDhcW51yQGkVNnuAggBgdGP+siVolscFDpndY1QmeDjCY/
         i/wgK3RBVs9CzlDIvi3RPB0/2EJgxekp7E8sPAsOYXP/FGE75mxlRjjLJcZMwVaB6hfz
         ehhMnE45fkQTgOJPObvHEH4swbEC/MvQRCdVhHLchON0Tyh0zLJpfMoExN6dTEa5hpVH
         uejA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708020145; x=1708624945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RTLhguGP2E+1eVlfyjhu3om+JFr1gOZVx4tF8A8nZOg=;
        b=EHf5YPe3zrTQXgdlkC/WfCxkN6lyRznhKi9FsFijbUViL3G1cVyOgu/XEB06XL8sxk
         BnEnrVMV1aG69IJBpu3jg7/nYMQJgx60//VydX1zhnyYpxJW03NLg+WP757yTxDaroH2
         JAO+gAn776Nn26TNtNN47i0QHQw1M/8nUsr/ymfXX/MvKFFnA5UVuTFT+Bx3uiMhQHps
         v2EphBWKKNaAw2P2YxgeFhSA2aTl6yCm4pt1BW0r6hDFelVW8DKnYq33arvN0ToXcG86
         UPVrDePn5A613h0CBxGh2sfBBpODb2XrivjCCb5g2GIm+5Mtm6C1LsSIesdhsqsyfVF3
         I20A==
X-Gm-Message-State: AOJu0YwM5h7THhjmbEg0CU1UKoTgYxihyfH9K5VO+ZSHxGy28bSVxVjW
	GXceyDzRVEzD4plXNGGEtWtVITBocl7uBGDtfigk2A/+DG0ZlbNA
X-Google-Smtp-Source: AGHT+IHZGtiJ+rxAtyUqCvO33A8aemrNJsTVP9SlkgPS2xAuUBoz8WqKJCwifX88x8B722sqANKDsA==
X-Received: by 2002:a05:6e02:12c2:b0:364:2328:22ba with SMTP id i2-20020a056e0212c200b00364232822bamr3112807ilm.12.1708020144864;
        Thu, 15 Feb 2024 10:02:24 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id s11-20020a056e021a0b00b00363ea5c0fb4sm496031ild.70.2024.02.15.10.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 10:02:24 -0800 (PST)
Date: Thu, 15 Feb 2024 11:02:22 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev
Subject: Re: [PATCH] bcachefs: omit alignment attribute on big endian struct
 bkey
Message-ID: <20240215180222.GB81623@fedora-laptop>
References: <20240215161957.112262-1-tahbertschinger@gmail.com>
 <Zc5IgMloeK/XkXR+@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc5IgMloeK/XkXR+@bfoster>

On Thu, Feb 15, 2024 at 12:23:12PM -0500, Brian Foster wrote:
> I can't really comment on the Rust context, but could you add a comment
> to explain why the ifdef is here? I.e., even something as simple as
> "Rust disallows packed and aligned on ..." is useful.
> 
> Brian

I'll work on a v2 with an explanatory comment.

> Also out of curiosity, is there some reason these two attributes
> together presumably isn't a problem for LE?

The root of the problem is that rustc won't compile types with both
packed and align attributes. However, rust-bindgen tries to be helpful
and when generating Rust bindings for C types with both attrs, will
avoid placing one or the other attribute if it can do so without
changing the type's layout.

For LE, the "packed" attr is unneeded because the struct is "naturally
packed", but the "align(8)" attr is needed because the struct's natural
alignment is 4.

For BE, the "packed" attr is needed because there are some members that
are not aligned (e.g., `size` has as offset of 23 but wants to be at
24), so rust-bindgen cannot omit it. Thus we have to remove "align(8)"
to get a type that rustc can compile.

- Thomas Bertschinger
