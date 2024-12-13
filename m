Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B5018BBBB
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 07:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074024; cv=none; b=DH1i/y/NLpuIu6UuNejM7rVJfwNuJ/cEttmJxVbHaYwMCp7qluMHl/doMfErg0Hq38dPd+wKuPxAsmao8rhM6oLQDby65mEJpPr7nD8Kos9FFOvAVx+6S8j1l1ODqArHReFs6Sd+k4x4yF+AoVU5Zhhadho7Txof9Fpyp7Uj7RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074024; c=relaxed/simple;
	bh=CcfoH39Ga3NCTNrM36chxRO9HsWzuEWi2LHHGfTWpR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=igG0iYVJKLnq45i+QszM3gTAaCoVUlEZq9ttJDB9kLebgV3d2ySO9tR4HB6WHNe4VQv1yA4WPm031GbNb8ealARE5hxq0EN0fWcphX4M2l8+k5Ja6cFN4Ba2SZokWA2I1oe13yezPvwE0yu6wPDFTvqj63vM7QWDiCYT7DZOdLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dXNsevQ8; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dXNsevQ8"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa662795ca3so493068766b.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Dec 2024 23:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734074021; x=1734678821; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ogEEtJXzNxHENgLOd4mF7OzCwBKh2LN69UQcTsNeWTU=;
        b=dXNsevQ8Hv+y882nhkY7LoD3l09ZhrUbTQXnnWBYJxQvVMVqoZ7eHvr9cV5s6GXbvD
         rTlV8AwAyzhICZrvfMyMlD8d0ZJ5hfZ9R4A1slaOdLOk/8mJC10P58pC0cLIJuRt4fB5
         xUP7jQ/A6WsrM8TCXWy5zUw90L6KZ33Zio0Q8hmB2bYTuXpDC7AyL8aOUY55xZajpvsD
         BPGwzA2kbzRJep9uc1D3dULdvzILnkjP7dhLeId/2huRbIjiteFMIb4mlTtpkShBJQPa
         RHrDag5D7kD7rEg+U91z/tNBuoCJsozCjBV4B+T91MD5GpR/3v18d7spECrb5PYo0ORZ
         Ii+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734074021; x=1734678821;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ogEEtJXzNxHENgLOd4mF7OzCwBKh2LN69UQcTsNeWTU=;
        b=aMowT2bIkBEgCqDcWj8MgUNNH4mc1OSC/CpshRgl0KItOR42hEkIomKFsbAl+jBFZB
         N5ff9/8YfxIc3k/Ec4kn4finya1oxUpihojI+3MAUEeY/YkaD2kNKvJti3wmUGLVYYLd
         cmmgKPmPSLzg8xvNQju388dReF87tDCacRBxMsnkslIHIDwPxkgFjRLYh8Qhlk1gIDP4
         lmdaMP2tUvIjfEKvDu2LHVFT3nxnxH9+9oZCan0RPqElpuWt8HH5uuilSk4kXGeCAJCZ
         FbpDOlUoLyIBxO74mk+OW1695yLUuOyBwGW7cpBBubikWvyTcO9sKrIrl+HQbVbvrk+g
         rPJg==
X-Forwarded-Encrypted: i=1; AJvYcCXErk7LVvvphN5BwXubAdUuKKzZrsmvYeHBx75AIuJJgg+LwW9Rr5ZK5xG6+olykVfDWG63VNaBJC6kKelXug==@vger.kernel.org
X-Gm-Message-State: AOJu0YxD6BfRvGHqV2Ytg3SW03M76IKlHi1cupzShy2HXYNoTNzm8iDw
	y7rRrZ7liSJtvP8ouk856+A99w6eK8Gdy8t6rRZmOprDKUnPtuH3mqABg1ob8wOZJNOkqatlIRA
	Z
X-Gm-Gg: ASbGnctzgKvxOYQQE5gYx+4WSmsX/+B7HuDmKN7+RrslUcB44WkNf3qDMJ5tWv7WKxF
	J9H0Nd+0s+NuMmeVFc+IAXJEkvnfMJbrlF8LsNm15C/4KeNA0/sFn6v6uHlS2FFQFG949DwkBvd
	28aU/02VjcewjvmIWnOvHY52r+yD2AQX+f9jM6FU5MbqMY6/0nZ4Ks4s6+uFuFMPBmkyVfR4lfQ
	hz2bzsCDxmvAWQvik2C+zTrBhcWzhFfreZIIQvgykHFGv+jDmgf/H80+gSFdQ==
X-Google-Smtp-Source: AGHT+IFbfXZCVIZ+/YV4BpaGAU/Xibo0YqHjTTlEMxiGHE+JH3CnJWYkryBurN4Ott2o2NVLHBmH2Q==
X-Received: by 2002:a17:906:dc8f:b0:aa6:8b4a:4695 with SMTP id a640c23a62f3a-aab7bb644d9mr128549866b.31.1734074020805;
        Thu, 12 Dec 2024 23:13:40 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa6b9a94c32sm268653866b.55.2024.12.12.23.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 23:13:40 -0800 (PST)
Date: Fri, 13 Dec 2024 10:13:37 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uros Bizjak <ubizjak@gmail.com>, x86@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-arch@vger.kernel.org, netdev@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>,
	Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 0/6] Enable strict percpu address space checks
Message-ID: <e9c4006a-ca1f-404b-bcb2-8b16ae2a9231@stanley.mountain>
References: <20241208204708.3742696-1-ubizjak@gmail.com>
 <20241212193541.fa3dcac867421a971c38135c@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212193541.fa3dcac867421a971c38135c@linux-foundation.org>

On Thu, Dec 12, 2024 at 07:35:41PM -0800, Andrew Morton wrote:
> On Sun,  8 Dec 2024 21:45:15 +0100 Uros Bizjak <ubizjak@gmail.com> wrote:
> 
> > Enable strict percpu address space checks via x86 named address space
> > qualifiers. Percpu variables are declared in __seg_gs/__seg_fs named
> > AS and kept named AS qualified until they are dereferenced via percpu
> > accessor. This approach enables various compiler checks for
> > cross-namespace variable assignments.
> > 
> > Please note that current version of sparse doesn't know anything about
> > __typeof_unqual__() operator. Avoid the usage of __typeof_unqual__()
> > when sparse checking is active to prevent sparse errors with unknowing
> > keyword. The proposed patch by Dan Carpenter to implement
> > __typeof_unqual__() handling in sparse is located at:
> 
> google("what the hell is typeof_unequal") failed me.

I'm glad I'm not the only person who read that as "equal" instead of
"qualified".

regards,
dan carpenter

