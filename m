Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49E41F4174;
	Wed, 26 Mar 2025 15:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004462; cv=none; b=k/N5iEwP5h0g8n0zm8EdD1kFZ+wslsPHCEBK0/LKJ60+9z0zHNDVArxobUwHYjYYAr8DcBsVAf2d0pexu/sXqAzMU8iYFSefyMpZqsTu9phMDWBZPYsOmZ8fRDNPW6MfabVyagkGPmqUjZAHXOWCFTgEJcGTlcMd+9EuC5zZFFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004462; c=relaxed/simple;
	bh=9x9x8oHWYuKJdHOwmFwOsSLmgI+sYfN1A6BLjyDwKtE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gLx4Pb1QjXABKaRmd9NUclp11sjKFiuJbHK84myytF/wilQIX8sYN9dcWKuP547gtbacYuhvX0QhJteYywxoD28o4ja3hN1vuAh1Eu0qr7Km644I8/iDNhkbSiPj6Fnr+U26IMU5uDwLut2byZZyeJGJ/cp66hn7uDgcnlTYG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DGwZ5lSe; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGwZ5lSe"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-226185948ffso1149235ad.0;
        Wed, 26 Mar 2025 08:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743004460; x=1743609260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kNsjzDh0Jt7vawFiBJDr9YacuCr7SCZoVydDMOKNNLw=;
        b=DGwZ5lSeOj1f5qgjObpUT3R8K0/IAHDLLxahnZLpvqdkbOWayJtO/Ll1X5XYI0Y5vC
         8zyChogJ9NmhFtDtvsaW879jBv15tzAix5z92ppjO5oV101VJWi8PHELMUlOEWPze4Ao
         OiPafQ6N2VmlpfTWeJfXwfSxkzPf7MoM9KER5CrLonOciyVzyrujl6m9Xya4BdW4sNyZ
         o82WU3MUH7aQOp/mj7z45gDCZlwud4H2bbQ0xENsF9phBdjdMl78AoW4B1seSHOG+PGd
         qF22gxA9MrAFeWLuQKsaafOG60l9Ob5YuFWjUkOmufYV1pBayiD8p+n2bc8r6duiirSr
         j2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743004460; x=1743609260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNsjzDh0Jt7vawFiBJDr9YacuCr7SCZoVydDMOKNNLw=;
        b=Fwv2MxzIJPjL/bvZw/4+noxg07noAq8xcD/vPltDwHF7EhPD1y5EKz1mgUQ9UfMpvw
         oeGUh9jt1ppeAdWliGqCmJ+F38tIOAgFfNrEmLlXtChiTvNElEp/U4XFLlnPiPyovdVg
         eUc3b0fbNANEyXJcaP0F2Ys7y6xFCpTyDSJqXci1tAtZ7hKr97l1jhRq9SZgtFdfF3+f
         gclDEI+rr2Di6yIUJm8wY7ls3cC1pr5yZRlC9No/Ntxc1nZ6X1hF/JSdwe5nDc110/6N
         20wfVkVrwUHaWNB8Q9+H5yGzIy1P1Pqcrs5rmUbZ6Jn88QYeQ4bZPkLlCVDIqZ3aUZXm
         fIaw==
X-Forwarded-Encrypted: i=1; AJvYcCXRvSkYKcVdSpS6mtDEnL4F+vs3En5fmmz1h3x5OtLBRSDjvvxO5uMZoDn/ayXg8QkIHzeyUsPjci3LhXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGwI8xiO/On5NU9so3OguJbYVysm2o0/6JKMKxXPmrIZ/M1Dv/
	cOpbhhqwBm/4XYwY1TkuTKcj2YYzANaGjbpiciC8yJwkWnaXc3Wl
X-Gm-Gg: ASbGncvzVMa+kgDtxskmSgNuWlVFruF1O5P3/yDCsjawAALOW1ZFZ/C35z8kuTdsBZ5
	tbp9N4C1YBkzkGbwCPflZdNF8DmaYJaotRlgS6HczreXiJxURao3WkpWZug2vtm3gWfZTCYsKAH
	BHIVSIg0hGmP1ourShuLWC++tUYSRu3UAuMz4bbbu1jO1xYtfQGAmtGYGEO3WvGnKEis8xQGo1s
	4wqWmOJtQiqQwnjAL0cVH5fUofyK51yChbVP6wkCM6Xsh2HNh4Od9THoSYgfecqO+nAvljDEJ95
	nLW7vSSGeYXotbCjvtVermzCog/JkMgYHlsajWNW9nM/qFPjF4o6pSFF70Csou7vRyjeV7pZ
X-Google-Smtp-Source: AGHT+IFibG/Hx3o4bDgzRVNPX+Xrit8AxA5bv6NYILxcH6jexjFBP0Ia4h5wCjCa0+Dtf5uszJ1IBw==
X-Received: by 2002:a17:903:98d:b0:220:c813:dfce with SMTP id d9443c01a7336-22804946d7cmr523815ad.39.1743004459669;
        Wed, 26 Mar 2025 08:54:19 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f45949sm111467035ad.63.2025.03.26.08.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 08:54:19 -0700 (PDT)
Date: Wed, 26 Mar 2025 23:54:15 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/sort.c: Add _nonatomic() variants with cond_resched()
Message-ID: <Z+QjJxcnAkeGIbCT@visitorckw-System-Product-Name>
References: <20250326152606.2594920-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326152606.2594920-1-kent.overstreet@linux.dev>

On Wed, Mar 26, 2025 at 11:26:06AM -0400, Kent Overstreet wrote:
> Andrew - if you're ok with this patch I'd like to get it in soon as a
> bugfix, I've been getting quite a few reports on this one.
> 
> I don't much care for the naming though, thoughts there?
> 
> -- >8 --
> 
> bcachefs calls sort() during recovery to sort all keys it found in the
> journal, and this may be very large - gigabytes on large machines.
> 
> This has been causing "task blocked" warnings, so needs a
> cond_resched().
> 
> Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> ---
>  include/linux/sort.h | 11 +++++++++++
>  lib/sort.c           | 46 +++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 52 insertions(+), 5 deletions(-)
> 

I don't have strong opinions on this, but I recall that UBIFS had a
similar issue with list_sort(), and they addressed it by calling
cond_resched() within the compare function. Would that approach be
simpler and more appropriate than introducing a new API in the library
code?

Regards,
Kuan-Wei
