Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F125229406
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 23:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726960183; cv=none; b=SJ72BXVT01jHU52iFFwAcrLo26ylLiVfiF8QeMuS8R25Ay8IzhykLwKfLUTmc2/rcxncNOyRbYiRhz2f2Wmu8+OsWNXXWnHsZ1AK3x1njuzbzcYFDilqiurcYjYf6ux7WJPRX7UZtUQykGFd3bBEmsZGGVQEEYlA9qSj+hybcT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726960183; c=relaxed/simple;
	bh=JVKkEjgDnvrsHsP4+HgSHPT8QpKNZnVX/t+QVjDeEaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=APuELvZYToM5gjIFOT4PMf9QU22Nm9DLRPXDiFsr5QPPrmrqfQoPZO26srQT4NdaBDTEF8mSxgdMRHQ6vmvzG5pEXyfHrYuabjMNek1wfqYfnjNg2+EmHs9P1RTExkNIrg3rheMVOw/NVsb7L/TynR2xJ8ise6dvGfSSbXKmRdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gk28sC8+; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gk28sC8+"
Date: Sat, 21 Sep 2024 19:09:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726960179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oEIEG7JNJJAyUjAVvLknpHoCi3kKztT/5coAPJXRDZ0=;
	b=gk28sC8+BTlNT8PVXopHOyEAN+N0H5ERnRgJpYp6xBJWGIra3xvDICHdom2EfrbWzZ/ARD
	uMTmzqgEqWJuWw80u3mcSpdwJFamulBDT9Deg3LPSMoVlhYWuYDplhIFrQJJIjSS8ophJ3
	pqC6HJdncDfABJlYRvKe7p5AJT8zgBY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Wedson Almeida Filho <wedsonaf@gmail.com>
Subject: Re: [PATCH] bcachefs: move bch2_xattr_handlers to .rodata
Message-ID: <aefz5eyvwuuj43n7u4lrscx3is3y7aj2fbavmxxvpu7kdzxp3i@tvzeq5ouxomy>
References: <20240914001122.119103-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240914001122.119103-1-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Sep 13, 2024 at 06:11:22PM GMT, Thomas Bertschinger wrote:
> A series posted previously moved all of the `struct xattr_handler`
> tables to .rodata for each filesystem [1].
> 
> However, this appears to have been done shortly before bcachefs was
> merged, so bcachefs was missed at that time.
> 
> Link: https://lkml.kernel.org/r/20230930050033.41174-1-wedsonaf@gmail.com [1]
> Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>

Applied!
