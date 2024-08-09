Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB516C448
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Aug 2024 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723244746; cv=none; b=fBXhozKJH+7H6B6l4I6GN0gNHDj6+xbS/sTvmcGmbPa0IuhkVxI2+/+W0RXGVr0OUpgfgcfkm4mv5N8eEyPYVxcgA4kID7Y1MiAeh6dw31YQ0dWLdEjVyjWkNxpmTQOtx61vJtxdt21qFxGAoKeTDBkONpxNVjktO9S3+7R6+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723244746; c=relaxed/simple;
	bh=kip/j2N4MU6D8qAnWjrKI+qx/Op9j8h8o+o5qlLzWHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qfReOI/qk6CSiGqzC4lXav7LSOMUgSkuicOP84eEBxpoU4iyw9m6MpwKO4/K2KhSSaRj7bCyNOLVjcHuxz30XvM/ZbXwVuGzLNwR8SzKPZzDq9E1lsr83rFOvsvNxKsTfxfZdCVSvLqMVXUZa2Yve8si32NoMRUA5MELUWgKn7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=3F0Tb9rN; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="3F0Tb9rN"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-710d1de6e79so1504589b3a.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 09 Aug 2024 16:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723244744; x=1723849544; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nTDcrQgyeVMDCz81y0q/ZpfGE+ROsNi+zfVoOYVwgYs=;
        b=3F0Tb9rNq80rq+VF0zWpz8JkUKY6UcGOxJpVQha1CnLGe70gSrGzFa0nSJj1DOlagP
         5VYOoSK5Uuy6mbmrFP6ySfybI4hsHQhw0u9OYlJ6W1BYQ0rYxnztqx0HZKUyw/efk91o
         WRAY5v8bd0VSMmd1N2fP0MuovZa/DtJhVnYwRCJm0OG81waDANDDKnl4M+Ozm0BG7Tex
         fzfs1gEXbpi2Y/nLzcl0vPn7pMS9QnKWE69kOfIvLiG4C1VnCgGGGXRlBW/pTICD/7kF
         A13ec9IwI6Icv2/bUEpNTvtFXW2cj9W8KBJth5ICTY1XIuIgAVUum/EzGp/SCnu8qTvN
         q2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723244744; x=1723849544;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nTDcrQgyeVMDCz81y0q/ZpfGE+ROsNi+zfVoOYVwgYs=;
        b=htqfgvlLarNrqDmTvEsknIbRQFS4D8g6ddLbqDaGCM/CCYaccKdSbz2AHQDcqSp+yB
         uqJs6T8nHjeG1KqToMS46GG3xgtB9L/1/ZjlFzpjdjXLtWkBg/YbjQ7vmJWpUv6s30Wm
         4dVRFmTCgsPyd+1WspNqkJnNJrxs6A1wraw/HBhU7Si7UH8S9mqOHpmwu+8tNdMT4ZoA
         CvfU1RAaX2eTiqy+dMmTW9SNy9l0i/8mGnBMB0eEI0d3ws2aKYcLYfqy+3TPEyuGl44I
         On+JiCH2D6X1sLP2wIIgMhedPzBAbs0/azAdSdGzmMDe+NKB7LX4MGCmuVSQhi3iE3R1
         vF4A==
X-Forwarded-Encrypted: i=1; AJvYcCUHrToOweZxMwiQVdQtNKN1ZC8J0rIUp7DCHXmu7j0w9OjR7Qec0vBMVXiU5sjMp9x51aZ8Yb7+jhVSmrWBleIQq3xUoJhW3EVmE+Eaa6I=
X-Gm-Message-State: AOJu0Ywp0cXN7cr1PiA7aEZepBacGGi50IdfYTUWGB3VwB0B1oFJfBgi
	TnMITorVe7DQWLJbW3zyFKmcNHS41jItU4brQetPsBCc6VZw+0EndxEN4TC4Zcs=
X-Google-Smtp-Source: AGHT+IFCLSKyX0YVdtgGjZlbE/P8XJNJvz1WTxeb29RoLQ3QQ2JHQrcHUzNiNqGJfplvUdPb5Eejhw==
X-Received: by 2002:a05:6a00:cd0:b0:70d:ca45:a004 with SMTP id d2e1a72fcca58-710dc760083mr3294863b3a.13.1723244743590;
        Fri, 09 Aug 2024 16:05:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-710e58735f9sm267932b3a.2.2024.08.09.16.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 16:05:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scYg0-00BQM9-1s;
	Sat, 10 Aug 2024 09:05:40 +1000
Date: Sat, 10 Aug 2024 09:05:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 13/16] fsnotify: generate pre-content permission event
 on page fault
Message-ID: <ZragxG7wkTsD1sdy@dread.disaster.area>
References: <cover.1723228772.git.josef@toxicpanda.com>
 <192b90df727e968ca3a17b6b128c10f3575bf6a3.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <192b90df727e968ca3a17b6b128c10f3575bf6a3.1723228772.git.josef@toxicpanda.com>

On Fri, Aug 09, 2024 at 02:44:21PM -0400, Josef Bacik wrote:
> FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on page fault depending
> on the faulting method.
> 
> This pre-content event is meant to be used by hierarchical storage
> managers that want to fill in the file content on first read access.
> 
> Export a simple helper that file systems that have their own ->fault()
> will use, and have a more complicated helper to be do fancy things with
> in filemap_fault.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

....
> +/**
> + * filemap_maybe_emit_fsnotify_event - maybe emit a pre-content event.
> + * @vmf:	struct vm_fault containing details of the fault.
> + *
> + * If we have a pre-content watch on this file we will emit an event for this
> + * range.  If we return anything the fault caller should return immediately, we
> + * will return VM_FAULT_RETRY if we had to emit an event, which will trigger the
> + * fault again and then the fault handler will run the second time through.
> + *
> + * Return: a bitwise-OR of %VM_FAULT_ codes, 0 if nothing happened.
> + */
> +vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf)
> +{
> +	struct file *fpin = NULL;
> +	vm_fault_t ret;
> +
> +	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
> +	if (ret) {
> +		if (fpin)
> +			fput(fpin);
> +		return ret;
> +	} else if (fpin) {
> +		fput(fpin);
> +		return VM_FAULT_RETRY;
> +	}

Logic is back to front.  Both paths have to check for fpin,
only one fpin path needs to modify ret:

	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
	if (fpin) {
		fput(fpin);
		if (!ret)
			ret = VM_FAULT_RETRY;
	}
	return ret;

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(filemap_maybe_emit_fsnotify_event);
> +
>  /**
>   * filemap_fault - read in file data for page fault handling
>   * @vmf:	struct vm_fault containing details of the fault
> @@ -3299,6 +3391,19 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  	if (unlikely(index >= max_idx))
>  		return VM_FAULT_SIGBUS;
>  
> +	/*
> +	 * If we have pre-content watchers then we need to generate events on
> +	 * page fault so that we can populate any data before the fault.
> +	 */
> +	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
> +	if (unlikely(ret)) {
> +		if (fpin) {
> +			fput(fpin);
> +			ret |= VM_FAULT_RETRY;
> +		}
> +		return ret;
> +	}

Why do we or in VM_FAULT_RETRY here where as the previous case we
simply return VM_FAULT_RETRY? Which one of these is wrong? If both
are correct, then a comment explaining this is in order...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
