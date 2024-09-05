Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FE6176AD8
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 19:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725564661; cv=none; b=ucLHyGIt8/ltb4uCJeQ03yPO0wj/pdQKXXMKurIIVioOxk4Bh738wFUsaPLu/2b1sQl0Pu5U+wLU3ogXvbFmf/ndsDUjv5s1MT7rISdigFWVr+isTpZkCq1V+eXWyrtuwxq11kBM5USTstZsTgtJgG/sAIgZTYZGwOKBTpfmKW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725564661; c=relaxed/simple;
	bh=aJZ8bQSkUIVqDFRiCuFHGmMzhivAESBpCNJ0n0n+DEk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r3krujEt+HXzxAy8YXkzspEF6BkUe2vHcnGy4gbl1OJt04URQB+cU0vXzZ/GpzZRW3xSb2+4m4OG72FzlQ0oJyf3Y0+/rp0lH7sM0c2N9Zsn7vmbwvXUJoOz7nDkmnbqGbZ5CV9oX3MXib/gUafX1tiZOO6NG1rV1M+s2pXpRbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=LXImTKbv; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="LXImTKbv"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-278279a3a39so757549fac.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 05 Sep 2024 12:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725564659; x=1726169459; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XWzsnrKOmtVghAOq6+Gelxt9/1OrdoNtOgO3/1pVemw=;
        b=LXImTKbv5+Ty10V4xWlmNZvDYRJgeXcvbNG0XEy+AUshlKSj/VCj3tueGQLTl4NKyh
         FVP6/nSCKWNv8x/l9vJLBO2JR2US1VrS7C0xa6EwBKiz68IV3KpuWYR8CXnQvtE5YJ5j
         ZKPhKepuqtlU38a2dfiWzoN+UNPC80S7qCnhXhD/pugOJtIK5n9zOz9AG9WVclfwYUOe
         GsABP1R6vzGbn5im88Eu6AP8YFeCxknFIH7DZyCaIVksygkhHamL8Q2vtE+yWGSeDdjf
         iDcsihPp17TXBdA4YpuvNfqLrouorWMD81JWAEwsfESTEiRmKsxLhKRSokTAK5sG+qz1
         eZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725564659; x=1726169459;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XWzsnrKOmtVghAOq6+Gelxt9/1OrdoNtOgO3/1pVemw=;
        b=rJ+9ZWcXpT+YlaGkL5tSak93scbBjtu/FrBY5URy+9+TPIbl0i51Bt8c7YjERzLRlt
         swirvWiWJpGM4kgpSBx+d1vgJEqgUjpxZRPmFGDTr4qoF7MpYXRMarWvzHMekhpKjHwP
         nqlvdzSOWN920TVl4+aDWNvht83KW/EOzHunAVMCxe+jhKh16ii4vDxZo+1018dGYANi
         QFDfaj/AXvrv+oR8aFM1/uA/aH3YKxgdt5GcjWu4KILLrNWWLLyL4l5m4kS77SxQgSD1
         8Y27eTEMWa2qz3rOUPDuh8hsGiZtjUH/3uxeBKfjQeR/9htKwkJQ7nPS0FLQ3qllAbom
         X/ow==
X-Forwarded-Encrypted: i=1; AJvYcCV7Oiv0nliQsqW9bYTDKQEdJJqBQ+aqFleptw2WqemVSgBQxilm4uxeQ8rCjkYJTN6hJyf0yak2PcQIwhQV1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzIX8i+WTf+fd9ClqaSz38fxiKY2Mm0zEVsiLkqcl3dlIWOdxuB
	cq6X2jSKf3DSxv2fUYURuGkSoUYM9FQsIE8/i+64iserVfnbILzvJPOjkocJEW8=
X-Google-Smtp-Source: AGHT+IFXdd+03g78Al1lMAeKqgNUOu/nJpHoXFDkr25DBgvdfGzY+Xz0bdnePSiuP1u3rPhxKsaK6A==
X-Received: by 2002:a05:6870:6111:b0:277:f301:40ce with SMTP id 586e51a60fabf-27b82e6745bmr338204fac.20.1725564659009;
        Thu, 05 Sep 2024 12:30:59 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a98efeb945sm100782485a.98.2024.09.05.12.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 12:30:58 -0700 (PDT)
Date: Thu, 5 Sep 2024 15:30:57 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: jack@suse.cz, kernel-team@fb.com, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 00/18] fanotify: add pre-content hooks
Message-ID: <20240905193057.GB3710628@perftesting>
References: <cover.1725481503.git.josef@toxicpanda.com>
 <CAOQ4uxikusW_q=zdqDKCHz8kGoTyUg1htWhPR1OFAFGHdj-vcQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxikusW_q=zdqDKCHz8kGoTyUg1htWhPR1OFAFGHdj-vcQ@mail.gmail.com>

On Thu, Sep 05, 2024 at 10:33:07AM +0200, Amir Goldstein wrote:
> On Wed, Sep 4, 2024 at 10:29 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > v4: https://lore.kernel.org/linux-fsdevel/cover.1723670362.git.josef@toxicpanda.com/
> > v3: https://lore.kernel.org/linux-fsdevel/cover.1723228772.git.josef@toxicpanda.com/
> > v2: https://lore.kernel.org/linux-fsdevel/cover.1723144881.git.josef@toxicpanda.com/
> > v1: https://lore.kernel.org/linux-fsdevel/cover.1721931241.git.josef@toxicpanda.com/
> >
> > v4->v5:
> > - Cleaned up the various "I'll fix it on commit" notes that Jan made since I had
> >   to respin the series anyway.
> > - Renamed the filemap pagefault helper for fsnotify per Christians suggestion.
> > - Added a FS_ALLOW_HSM flag per Jan's comments, based on Amir's rough sketch.
> > - Added a patch to disable btrfs defrag on pre-content watched files.
> > - Added a patch to turn on FS_ALLOW_HSM for all the file systems that I tested.
> 
> My only nits are about different ordering of the FS_ALLOW_HSM patches
> I guess as the merge window is closing in, Jan could do these trivial
> reorders on commit, based on his preference (?).
> 
> > - Added two fstests (which will be posted separately) to validate everything,
> >   re-validated the series with btrfs, xfs, ext4, and bcachefs to make sure I
> >   didn't break anything.
> 
> Very cool!
> 
> Thanks again for the "productization" of my patches :)

Thanks for doing all the heavy lifting in the first place! Glad we can move on
to other things from here,

Josef
