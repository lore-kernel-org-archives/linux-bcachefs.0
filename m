Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C527FB31
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jun 2025 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751035568; cv=none; b=XB8H3aHTHTK2q5aWa5OczX+rGzPZmnAAl1Cg+7xzUgKnRPmWVgYf/aZu+BWCsofo869K6m2HlZMe9bgxt5nEU0G38CrjkH6XS5G/Ms465vdgNxSPKtkttQ9tf+YcjF2M4tDk+7nZOmAXZWLEsIdXeCYASXiA+FJ+5+s5+eZCX4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751035568; c=relaxed/simple;
	bh=E3Y6IzzH6pxPxtBDBUSfanZZ39PEqoGxRtLOhfbrYg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MiSRfNTZjdnnKPoV1Z6qxPzqkgDZzWO2Cclxz2yg9NjBzNkVZ+goksDc3bajYcROmlXkI+Pixx9kVTdgzHIC6t8c+tvsZFPV8bi8h/uBKDUjRAxpXg0W7RhXGCbyPAgnTKEvY8FPZEdrj71GVNKDNYL8z8Jb5eYIFTflqKZGJPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=vtmBW32g; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="vtmBW32g"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4a76ea97cefso24757781cf.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Jun 2025 07:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1751035566; x=1751640366; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cRZ2pYMMlB12bEyOWlLPzPkRWlImskMORgDF4tKP1qU=;
        b=vtmBW32gyxvDT3+DEMFKOabrGzfxEuOAEpEHM77wLWw++0FvVkCREW5rRuFv2FI3/r
         S1lnu1IR6RPRYVLh2mZlHptrHCRCzJZzEn71R/U1ydDs2q7h1UUbZUvQDbi1VUtZkcoH
         2s418vmzJ29PPnYZ+lzUzhuMo4GUJJ2TS6cOGSE3yMHHlwgtfGo7I4EbTBCkQuQd3WUD
         OwygcdD0xHENTo2oq++ppyFDVptBXNqah+FxO+lXWdOeWOb0QYhsPda09M/GaRgzhQOL
         aXAAK8L7J+kAQUfn7REOwMHXSGEQ/41VuSM5rJUMcyzN2/FeWYpIB28rf3CK0AlCj4q9
         BfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751035566; x=1751640366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cRZ2pYMMlB12bEyOWlLPzPkRWlImskMORgDF4tKP1qU=;
        b=dy/zQsBnDGx2ji/fFktRHmz0N9rQg7Zer6Z3e/x9n2u5YXWVPq2wHqBwiMu05uNxw3
         8YZKwxqGGTXStq9kQQvMnxAnE6YX0+xrnpXA4KEWOl8NG/2XMDJAtn5iWwHGlIlrNNDB
         lgjWYXhr+iMY91V9LKJGJjhVCmWXvNx64FwP8P84brre5eKk1cqLVFWW5Sj90zVcG71j
         BNyNfUblwA/abd9qsqdo8wLXQ5dziUbq3XU012LY2iznGTstVZcsvs6n6jnIGcLS2zCM
         elk6XkYnlSpDEIB5RMce7ulnTU5FuJ1Gqpcxv7MyXy0bBHhc1HWYmomuwVmsGbHrlFyF
         CPtA==
X-Gm-Message-State: AOJu0Yw0PSXJiFaDwCk/aSdXwUtxZH8m+7+L9nlYiFbUHlxWEpX4IBZA
	iBCHPVuTQ/RCRa/6gmHKR4o2S5EkJJC1+LFIXtw6rp4+iaIDMJ+Y1/Oq4tNAMWfWMGo=
X-Gm-Gg: ASbGncudhHQ7wdZBTAYRTXUkiBnVHiwp99SVUO1MYw9Dwvw5Vpsuqy5j2O0QDQUyW44
	52rShQxjsaMcBIr764W5JYJky9UQmx0+fFVGtzx2Hg/Yd2d3uIXyYH3RBrpM32QYW2IzxCUBN3x
	/rWXT//Q6yHWEGytlOGZh2HkqYK69OxerDpnRedXbF/CYXr8flf5AUSATUWPQ2jH/4GYNBeCwI5
	CmJEE+u3MgfRm9cpsDUYxG2iPdVYcy5aygiLB/JzHrTqyFWtQIhjgrij3XjNpupmXn0hp+74Cix
	JpJJvsDZ8dD4nWZqv6GxcjJwxCsgUlRPlPT2tM5j5IxCOQqIjpHPoHxG4rURbJ54E5i5RFb4u3m
	mOKKGeK0KZaTcMzd8k8eAeps=
X-Google-Smtp-Source: AGHT+IEl0a6FKcst6Ik6YqVg0aAynT4+CuhWSr+flkm8BIm7KHjl1Bb3vmzdqMA+uCtcxDKZ0P3SuA==
X-Received: by 2002:ac8:5ad4:0:b0:4a7:6ddf:f7de with SMTP id d75a77b69052e-4a7fc9d7dc6mr61049981cf.1.1751035565530;
        Fri, 27 Jun 2025 07:46:05 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7fc13a60bsm13628811cf.29.2025.06.27.07.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 07:46:04 -0700 (PDT)
Date: Fri, 27 Jun 2025 10:46:04 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc4
Message-ID: <20250627144441.GA349175@fedora>
References: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahdf2izzsmggnhlqlojsnqaedlfbhomrxrtwd2accir365aqtt@6q52cm56jmuf>

On Thu, Jun 26, 2025 at 10:22:52PM -0400, Kent Overstreet wrote:
> per the maintainer thread discussion and precedent in xfs and btrfs
> for repair code in RCs, journal_rewind is again included
>

I'm replying to set the record straight. This is not the start of the
discussion. I am not going to let false statements stand by unchallenged
however.

Sterba has never sent large pull requests in RCs, certainly not with features in
them.  Even when Chris was the maintainer and we were a little faster and looser
and were pushing the envelope to see what Linus would accept we didn't ship
anything near this volume of patches past rc1.

And the numbers don't lie.

josef@fedora:~/linux$ git tag --contains 1c6fdbd8f2465ddfb73a01ec620cbf3d14044e1a | grep -v rc > bcachefs-tags
josef@fedora:~/linux$ git tag --contains be0e5c097fc206b863ce9fe6b3cfd6974b0110f4 | grep -v rc > tags
josef@fedora:~/linux$ for i in $(cat tags); do git log --no-merges --oneline $i-rc2..$i fs/btrfs | wc -l; done > btrfs-counts.txt
josef@fedora:~/linux$ for i in $(cat bcachefs-tags); do git log --no-merges --oneline $i-rc2..$i fs/bcachefs | wc -l; done > bcachefs-counts.txt

josef@fedora:~/linux$ R -q -e "x <- read.csv('btrfs-counts.txt', header = F); summary(x); sd(x[ , 1 ])"
> x <- read.csv('btrfs-counts.txt', header = F); summary(x); sd(x[ , 1 ])
       V1       
 Min.   : 0.00  
 1st Qu.:10.25  
 Median :19.00  
 Mean   :20.48  
 3rd Qu.:27.50  
 Max.   :55.00  
[1] 11.77108
> 
josef@fedora:~/linux$ R -q -e "x <- read.csv('bcachefs-counts.txt', header = F); summary(x); sd(x[ , 1 ])"
> x <- read.csv('bcachefs-counts.txt', header = F); summary(x); sd(x[ , 1 ])
       V1        
 Min.   :  0.00  
 1st Qu.: 38.50  
 Median : 70.00  
 Mean   : 63.86  
 3rd Qu.: 81.50  
 Max.   :137.00  
[1] 45.28218
> 

So even including the wilder times of kernel development in general and btrfs's
specifically, our worst window was 55 patches, less than your mean.

These are not the same thing. Do not equivicate the two.  Sterba is a phenomenal
maintainer who does his job well, manages to work with Linus just fine. We are
not the same, we do not work the same, and we absolutely do follow the rules, as
do 99.99% of the kernel community.

If xfs has done this then good for them. Those developers have a track record of
doing the right thing over a long period of time. Btrfs for sure hasn't. Thanks,

Josef
