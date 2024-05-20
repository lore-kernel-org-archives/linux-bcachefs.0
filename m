Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170948831
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 May 2024 02:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716172782; cv=none; b=gqAp4b7R/5iNTOOp6sne7X0tFL8N6y4zagMU34mIcfEH/tXuCYP0nPneAHP6+vJnYgR/yF0qY9+D27uWCV04k4WSWC47dM2Qj6yqfyrsR4Z0dLKS/onz6EO6tPXAxU4k03oW0w3gBxQSjx9u9qPGpdLB0DjqyRqI/XvHmuh/bXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716172782; c=relaxed/simple;
	bh=Bhzmt83JZJ7YbBBVl7j9UCoBQNog5AENdsi/u2ZQ81w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXS8k2U5pY8QxVaQ+zzmHZx3FOWgcLdNoRFQA/9A9jVB2H8PvyMpXTbE8N5JKtgF/yKovZ0MMicBrNuVSsW1sed8hO/t4Ccpn6Nsti/W5lmH5Zw5nEJsqLQR5GBB83ny5NCnT8oYLwrK8yQSrKBexHA5H6U7+izfvKTvVqt9z+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=RC6RLKlP; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RC6RLKlP"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1ee954e0aa6so27790925ad.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 19 May 2024 19:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1716172780; x=1716777580; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6rTDBlCNlynymCY0SceyeFw42XoD5sBEGAEjkXsg060=;
        b=RC6RLKlPhVmGkxXWgtKNSM+ScqX1eFP+k2QZcWRBN9GYrdB85SXKRh072Xd45MZCxE
         fEHAOqqEjQiSIgA1CguclJPKBum2BlVVnb806xDHBOgYRznvHGIgxwOpTQS8uAaDmqoV
         Jml7yYLXPA3rGe8iRN8JA4zD/BrBFNAOo8seI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716172780; x=1716777580;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rTDBlCNlynymCY0SceyeFw42XoD5sBEGAEjkXsg060=;
        b=MPKjliHYiU4F7GWR6uOz400rd6du4tk8OxoLW2Mx2i5ufWxzWin3C0rzZ1unuAmGJD
         OBTQxhSK3Ny1bexqNRb0xtaSJeyESIxpiULExWZs++dQhkz1l4xQFlaxsjNbNC7qJY8T
         m6Gzf4H3+WeuHvMSPQMd8YJIWvRp6YC7JSUTcygtEOBo0vU1T3ZOCYFnilWdjW0OnVuX
         mRRkOpEsqLJjzmP0ciUr/f64RKuZauNH3723XIbVyOJIgGKcgejgCywJ6sZ/Li5m3aan
         jqFZd0Gar7r3dlCfJJLOlMe4bkD8MlgAVUdra/FEV/aNq5rhqPbs4PQ3QhQ91+y4n1te
         ciBA==
X-Forwarded-Encrypted: i=1; AJvYcCXNIq8ER5cwi54oJPMpUkWjZFAqQgq9X7kwMGtavPqDUEl9CUfYqfccd5+5TxHGvvI1j9ytZdnRjXc9/zo0BTMQr+t5St+2ylMiwBQyO/k=
X-Gm-Message-State: AOJu0YwfvbM7WpeRHeuNtIPD+ARQCYc0QDRVsPpyuPosz4mwLSYC1wL6
	WDn/AjXWNgB6ZK/mvCvA+WMSKf9Vf+KVeppObiou8nW7udiM8PAr/f5q9IzIi1jPWzrvndUz/O8
	=
X-Google-Smtp-Source: AGHT+IFS+M442UZQ/j1zlqi20uZ+ipUZA3R+bFtoseCPoe4S0YNUA9TI6FC3wI5ePXaO8d8JsgwJjw==
X-Received: by 2002:a05:6a00:a26:b0:6f3:eaa2:539f with SMTP id d2e1a72fcca58-6f4e02cada1mr33633442b3a.16.1716172780342;
        Sun, 19 May 2024 19:39:40 -0700 (PDT)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f67a1b1c17sm7572989b3a.138.2024.05.19.19.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 May 2024 19:39:39 -0700 (PDT)
Date: Sun, 19 May 2024 19:39:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Kent Overstreet <kent.overstreet@linux.dev>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs updates fro 6.10-rc1
Message-ID: <202405191921.C218169@keescook>
References: <zhtllemg2gcex7hwybjzoavzrsnrwheuxtswqyo3mn2dlhsxbx@dkfnr5zx3r2x>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zhtllemg2gcex7hwybjzoavzrsnrwheuxtswqyo3mn2dlhsxbx@dkfnr5zx3r2x>

On Sun, May 19, 2024 at 12:14:34PM -0400, Kent Overstreet wrote:
> [...]
> bcachefs changes for 6.10-rc1
> [...]
>       bcachefs: bch2_btree_path_to_text()

Hi Kent,

I've asked after this before[1], but there continues to be a lot of
bcachefs development going on that is only visible when it appears in
-next or during the merge window. I cannot find the above commit on
any mailing list on lore.kernel.org[2]. The rules for -next are clear:
patches _must_ appear on a list _somewhere_ before they land in -next
(much less Linus's tree). The point is to get additional reviews, and
to serve as a focal point for any discussions that pop up over a given
change. Please adjust the bcachefs development workflow to address this.

Anyway, in reference to the above commit, please scrub bcachefs of its
%px format string uses. Neither it nor %p should be used[3][4] in new
code. (Which is, again, something checkpatch.pl will warn about.)

Thanks!

-Kees

[1] https://lore.kernel.org/all/202401101525.112E8234@keescook/
[2] https://lore.kernel.org/linux-bcachefs/?q=bch2_btree_path_to_text
[3] https://docs.kernel.org/process/deprecated.html#p-format-specifier
[4] https://lore.kernel.org/lkml/CA+55aFwQEd_d40g4mUCSsVRZzrFPUJt74vc6PPpb675hYNXcKw@mail.gmail.com/

-- 
Kees Cook
