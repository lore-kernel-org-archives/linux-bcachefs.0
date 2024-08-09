Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1227194C84
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Aug 2024 14:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723212953; cv=none; b=bWyNebWC1oFNcXNzhu85ZJwhWPksefSSxex8NHtRe0cOHFlAmSELm8bBkBt1tgXJUiiGIVQuIrITstHprMqleirTDYQH7v6vk1KvRScjOL/47UM6Ega14BAX9zU3DQCaG2QowrrB0FW1Oi0bVZwCppJDzq0GsyHPZZWYZ7pzWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723212953; c=relaxed/simple;
	bh=LpyRcD+ea3Jdp/nt2MlljsOpqITTF/5WPLQdiyEFQoc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bzKagdlAam589knFNfVah8inrQM1bci7TXK8Ozx+qXjdZFlCRR7837f0uaPC9KvSx/ds4jDMWRS+DshuZ1MOvByPrRSrRCNJeS4/Jg8tmYaK+lYojU1lZghTvMIJIVw1s+xHP9pqXRENlIaqamwEP2nsaCpkTuy4pnjXSCGeUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=p2e6ZgVc; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="p2e6ZgVc"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7093ba310b0so940417a34.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Aug 2024 07:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723212950; x=1723817750; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qjz2iKWP20OEyPShdLMLvLzhS5bKm3+7Fe0VrhQtc4A=;
        b=p2e6ZgVc8HRvca6+qmNO22eUNW5XLtUUY0ANVyzCXyBAYZe8WaORYSWePoOfQ1/3i9
         O6gMkqL/rIPAFHXiTutd5VyMyaR/TxmApqfgKj3wQRf/R7KJOCLsggGkslCvZLAG3xPf
         EN7GLdsAZR4Z1CE6jyUvtX8ilFEJCWoyRXwLltFGHZ+RW3u/GxJr7g3vHuBhJ8b310uH
         CyIyeFSxXrAymMkANSUmCHPToh0JHEDDVbM6esCKgllNzy0xLP0eRPso8kPVCE7aXBaU
         6TkTyK3IxIRxp1wC89QX7hwFS92BYAF7ubduMjgP6WlNdd0lhacGSYHbAdjR5LOYpLMn
         DwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723212950; x=1723817750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjz2iKWP20OEyPShdLMLvLzhS5bKm3+7Fe0VrhQtc4A=;
        b=FBU4/6VwYnsBhAxr+3GdkASvCKZprvb8Iu0KS5L6+M4E5Jdvi2TMnvuxvUm9VOLQS5
         sz4LjJmILb5mHfk2l0OPOdslfEyg+69Krz4/PVBG3oEOYYZq+soNad1B0nIrg7mzi5ka
         iC7hPf+bMSGYkR4s8wOr2qy1CzCRmn8h/nS4yQR+qQHM0ER8vI8LWlHTPk8VMNfAyJN3
         0Q5yKE5j6dVkKjev2K+9UzCyJPICWHjtu/vGimEG1tSGGIsTZM+Bz+PVTy14Q5qNDY1E
         6De+ugyvPbxu0KvICxSqLBt0+92/JcAUNcSEnX+UX+83iGD74KkXFZP48SVoNFx9GXzo
         87Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWIpsbCKxtC3/VENYgURKTYhvrVCrLeuzpQpb7DjxTPCU3YCgtzpiNZqTYYQxbdH/42a88a2heig4hkpRrVKsMXrIQ/BTxuF6krdHI3d+Y=
X-Gm-Message-State: AOJu0YzHJFeQ0BuYMInCcXhKasM9SfkeZzICkTUfLmcnsW8rbpkLkDzW
	wn1oBMBP/hB9UlgPaazZpxYCjhYxBexGkZ0Kw5bBM0+Cs0yQ2Ir5+oxjwhRAq0I=
X-Google-Smtp-Source: AGHT+IGEYKuTYzX7n9Q4WkJAqsc2BKy4Op03cbPrmVLdwnUtrw0LcKrosgOY3AEQ0Vv59SDfcwKgvw==
X-Received: by 2002:a05:6830:611a:b0:703:5c2d:56a7 with SMTP id 46e09a7af769-70b74879a7cmr2362612a34.24.1723212949757;
        Fri, 09 Aug 2024 07:15:49 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3785e1f93sm265995685a.38.2024.08.09.07.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 07:15:49 -0700 (PDT)
Date: Fri, 9 Aug 2024 10:15:48 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Dave Chinner <david@fromorbit.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 16/16] xfs: add pre-content fsnotify hook for write
 faults
Message-ID: <20240809141548.GB645452@perftesting>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <aa122a96b7fde9bb49176a1b6c26fcb1e0291a37.1723144881.git.josef@toxicpanda.com>
 <ZrVAvQLfP8fNSJwx@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrVAvQLfP8fNSJwx@dread.disaster.area>

On Fri, Aug 09, 2024 at 08:03:41AM +1000, Dave Chinner wrote:
> On Thu, Aug 08, 2024 at 03:27:18PM -0400, Josef Bacik wrote:
> > xfs has it's own handling for write faults, so we need to add the
> > pre-content fsnotify hook for this case.  Reads go through filemap_fault
> > so they're handled properly there.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> >  fs/xfs/xfs_file.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 4cdc54dc9686..585a8c2eea0f 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -1325,14 +1325,28 @@ __xfs_filemap_fault(
> >  	bool			write_fault)
> >  {
> >  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> > +	struct file		*fpin = NULL;
> > +	vm_fault_t		ret;
> >  
> >  	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
> >  
> > -	if (write_fault)
> > -		return xfs_write_fault(vmf, order);
> >  	if (IS_DAX(inode))
> >  		return xfs_dax_read_fault(vmf, order);
> > -	return filemap_fault(vmf);
> > +
> > +	if (!write_fault)
> > +		return filemap_fault(vmf);
> 
> Doesn't this break DAX read faults? i.e. they have to go through
> xfs_dax_read_fault(), not filemap_fault().

Oops my bad, I had it right before then decided to make it cleaner and forgot
what the original code was doing, I'll fix it up, thanks!

Josef
