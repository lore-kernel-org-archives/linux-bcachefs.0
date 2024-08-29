Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7B71AD9DE
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724935327; cv=none; b=cR1i6zebBmnlu4ibDBasfECW4dPcULk4lzYBPqHOh4kzSUQVGJAL4Gibp/bQAvIYGr+lc43MQvaSGeSZH7C3Nkfb+x7Ak8nVhXxcmrvoFj4tTQa7fjokFBUpWxlUs2SHOCya4Opp9USZdmHbIGQME53ot2mCRxxm9Dm/r4Bij5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724935327; c=relaxed/simple;
	bh=rPTzSrrL44gBi+TXZ2hY1ABQe2FEI7q+NKSsoU3u77o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fwCq+nPeLeab+UX6nmpg2MQdc3Jhy7twijXE4s4l7N+jnXU71z4bOdd95UKuDXXDnuyyIOH0Pa1gJWtQ6ibKWe50O/B7o9pzt1V++6u4Fk5IJcmoQi/0GhfR2gY7jqh2mXH5uhRDt1/lTvuDBKPpJsHhZvXgvRHNanKtfSUc67c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Rg2iW+We; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Rg2iW+We"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-70f645a30dcso100356a34.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 05:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1724935324; x=1725540124; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FVPDR0EpectGlXjsBS1JG87x2k26ixV87HJkZnRLrOE=;
        b=Rg2iW+WeOk3dyEMoUEBAZrlngLG6MQB7ShlrwSyWUlDCi+yE8JTaGrS1s1ViY6CMmz
         mkzi5f6vnfm+BoOMV22cSwoeY+89/9YmfzaeK9WMmtK4dwlXn5Qi1hmGKRC+LprrWAM0
         KQNqjwPH8q5vFDyTG75AIwCi3UQRvxN0TR3V8ic7Oq333HmInhrWCz0dmFGjukOEq+8O
         SO6h+C7KSNNRJv3Fv+wwv8RD+MWibpksu0GtS6v/f07k7mHO4HBG+JgzeMTJLdKS8oDC
         Lkac+eRF/uVx3hv7AoyfQCV1vZY2PbfVG4XLILri6uCJFKOm6t8TqswwHc5jFbXyfhCN
         1/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724935324; x=1725540124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVPDR0EpectGlXjsBS1JG87x2k26ixV87HJkZnRLrOE=;
        b=Fdm+8Rio0AAXCvy72Hre0Gkjf0xQqRBVEUuznSVf1HVLVbyMj3VGEwtk1PlUSchXPW
         379MoDc5S5tYVg/OcrpecQ24BbE6zvM2YLAzp3r5l8/axZtC3MmJHbx2kjuv01pBsAD8
         HZrNQqTELzWgGIl4AZbAA2tsBdSaFkdz/JEzkZ5IdQs/0gbEFaHlObGhUt8eas3GarkQ
         P7PLTFbVOMCwZuvnHlf5Ba8YidZvgzzhYbvHKuMuqPKdg3I1KtwMBNNmwdpLE1OwICAU
         WEOyV5B+re5ocUOr6h2ulkoFZs5th6xI3qE6aYyEj9xk94BiDaDa2hOBH7nWLIzQZHIa
         PUYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcvwK/AwYdnDsgdw8+0p7Y1teQqpLl0x+mKX0ySx9eesfjxf8JKxVWA/a8nM+okklyGEZ8PTHz73xLkfWi9g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJn4/lzUpSoAKSSwS36j6fF64YdWejIj6YrFiHPD9V1mKkQcqp
	svEUthzjhne3kPX2+g33Wa7FCv8obUzibHnr36Nr1QpjRWu/vZOWjzw6fkfzCSo=
X-Google-Smtp-Source: AGHT+IERjQ2135hGQyZwiYosgx5A9+JFDCAJw4M5MqUbqQEwCfNN1chSfcV3K03nBIADv4Tc9PUPIw==
X-Received: by 2002:a05:6830:4985:b0:703:7a17:f24a with SMTP id 46e09a7af769-70f5c21d1c5mr3939782a34.0.1724935324156;
        Thu, 29 Aug 2024 05:42:04 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806d3a047sm47621985a.98.2024.08.29.05.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 05:42:03 -0700 (PDT)
Date: Thu, 29 Aug 2024 08:42:02 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Jan Kara <jack@suse.cz>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, amir73il@gmail.com,
	brauner@kernel.org, linux-xfs@vger.kernel.org, gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v4 15/16] gfs2: add pre-content fsnotify hook to fault
Message-ID: <20240829124202.GA2995802@perftesting>
References: <cover.1723670362.git.josef@toxicpanda.com>
 <2bd333be8352f31163eac7528fdcb8b47a1f97b4.1723670362.git.josef@toxicpanda.com>
 <20240829111510.dfyqczbyzefqzdtx@quack3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829111510.dfyqczbyzefqzdtx@quack3>

On Thu, Aug 29, 2024 at 01:15:10PM +0200, Jan Kara wrote:
> On Wed 14-08-24 17:25:33, Josef Bacik wrote:
> > gfs2 takes the glock before calling into filemap fault, so add the
> > fsnotify hook for ->fault before we take the glock in order to avoid any
> > possible deadlock with the HSM.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> The idea of interactions between GFS2 cluster locking and HSM gives me
> creeps. But yes, this patch looks good to me. Would be nice to get ack from
> GFS2 guys. Andreas?

I did a lot of gfs2 work originally so I'm familiar with how it works, otherwise
I definitely would have just left it off.

That being said I'd also be fine with just gating it at an FS level.  Thanks,

Josef
