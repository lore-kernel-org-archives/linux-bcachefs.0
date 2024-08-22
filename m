Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF6C13BC02
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724308567; cv=none; b=GHWrAoAC7F/fI/KTCpU+N2tacOpdlUl8ySNQ3BIq/58P4L6qlgzp0RvD38hlNXvCAsQ80jxdNwwj5j52oyxzgsUFNA2Dmyv1FsIJv2+soRqesbSwURgqtAowkw3m2gixejzkgi2+q528nbT8yXVCpdgISg16E1nm7DtwnkFNLRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724308567; c=relaxed/simple;
	bh=YYRZKY83NhTEEWCRstoorUA3tZ1kfLMmksgfFQQZPJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVdxUo6UKgwgdBNxstUFdO1WlslLGycLZ5NyF+7R6kX4HMglzy/b6JgOEGrmmBOIlE68sTIGapRrRLJeC32k8aoax+4bRlyNDjv6AODOWxNAJ1B7c6Cr1FInDN4GPON/lUVfA+kFkmkMpFo80e9LH79eLLLCS5aB07hcbeyZSFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y2mRCS1l; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y2mRCS1l"
Date: Thu, 22 Aug 2024 02:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724308561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4hldB3EXQE5gPgGKgidKLfdyEId7PDYm7eacMW8ZxeE=;
	b=Y2mRCS1lknsIIJ5HMC7e8A5EuaGv0ayuMhRnLeuwr2PWVxgJRAPKycKHltqRehETaY5aCm
	0ADKXDpCiX/+7xTyt+xVj41iD/ioPQzjrnj6XfMMY065u36DbTGThsNt0PINhnTyBn9GXH
	lYNvMfalrffOQkEY1ZPPuPHqZU9to24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Yuesong Li <liyuesong@vivo.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	opensource.kernel@vivo.com
Subject: Re: [PATCH v1] fs:bcachefs:fsck:Fix double assignment in
 check_dirent_to_subvol()
Message-ID: <tge2dhrjuurcwahfzto7tk7tuxjcsbhhc4bl7ipw7w6xidyq7q@24fvb6vbkez2>
References: <20240822062158.1314554-1-liyuesong@vivo.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822062158.1314554-1-liyuesong@vivo.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 22, 2024 at 02:21:58PM GMT, Yuesong Li wrote:
> ret was assigned twice in check_dirent_to_subvol(). Reported by cocci.
> 
> Signed-off-by: Yuesong Li <liyuesong@vivo.com>

Thanks, applied
