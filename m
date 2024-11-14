Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D615D1C1AB6
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Nov 2024 02:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731550886; cv=none; b=ppqHcAAx1axi8T6TG/jE6BqcY5eorLhWnha/6AQicQz1zBRXZ43G6hrWsvKr4410X6GyQ+hSDLHKBYSh0uWc02eQKhWPEycUMPZ02tVMbPOTGsoXqXMWhl/CLk24blSDjXJpvut2MaurEKdZTBIqlRqJuOhP2kI+DQYXQIajit8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731550886; c=relaxed/simple;
	bh=RE2CXYNlXFs7UjcGJIWghnLBpkOzRz/lp8itW4y9QnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwLMXdR+EgSmpZEU10Xs55ik2/lOAxoaJSmi02F0j7DeWIQjyGuC2KKY12NdER464QxGZabku0Kur0ZV5C5VtGsm99wfkINR2+n44DokA02MaMJs757H0a5WHrTNvFiJlrgIBjQD0sT4IcqzMABoIAjJOqTpu6+LuFJQjhV/9J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cfzuCh3T; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cfzuCh3T"
Date: Wed, 13 Nov 2024 21:21:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731550881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RE2CXYNlXFs7UjcGJIWghnLBpkOzRz/lp8itW4y9QnE=;
	b=cfzuCh3TBu0DpzkMKPRYdALoCnfqnD6hIj+WxAMnr6krgZ4tUgbIJ5QL6xsZ9f3ml9oBNM
	TXKNMBVDOsKdSkYsxOVki3+A+Jlj/0whGLew6kaQGC6cJ6RMpZbnuPRbatIufd60bCT7o/
	L8cYbS0736p2l5R+96lyFd0OymaCYJQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Daniel Yang <danielyangkang@gmail.com>
Cc: "open list:BCACHEFS" <linux-bcachefs@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: replace deprecated strncpy with strscpy
Message-ID: <tykjpjsmjnkdfm24thl5auw7m2x6wmopvwtefcpjamxyryiih3@guovfh2cqe5k>
References: <20241113074248.175133-1-danielyangkang@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113074248.175133-1-danielyangkang@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 12, 2024 at 11:42:48PM -0800, Daniel Yang wrote:
> The function strncpy is deprecated due to not guaranteeing the
> destination buffer will be NULL-terminated. The recommended replacement
> is to use strscpy().

strncpy is correct here, we don't need the output to be nul terminated
