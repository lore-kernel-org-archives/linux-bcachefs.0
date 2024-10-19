Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6E414A0AB
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729371728; cv=none; b=UasDO+QqGPLnosZDswxRrt9tAnqRY6YNaTp5yGWtyQ4vBhvH1xAX0SIVvkP8JrO0uzQ3PmIbFuMwme2odX9K1ds4+F7VI+iAVY04qD9Ug2xQMXIYha3SMwW2Fbs4AYxD6NsDe74dCe9HKCEMklkaCYt8zQbQMnjHFEjPqqHV6D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729371728; c=relaxed/simple;
	bh=AtIfqzSH5fTCS2wKO029yMnpCJgKGu6tdkPTJh8eO6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9JIefVo0m1fJ75ETkj0sj1o8+S/8M3A1kKWJvCeDMbYfZOOK0Gy9w618Z94zPvSppLjZ8z5cc4NCCgFA63I/3+bK2UQDaKrePlcmah5GqdPkDw2rfij+NjYBAB88sd+0VIoaYax08s/JKSzAD9z0ptuDAb7wAWWjAc+IV6mLXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VWQEPJJU; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VWQEPJJU"
Date: Sat, 19 Oct 2024 17:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729371724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s/vAKQFCMOzQqMKWrph46vUHl2Tzsao3UHLAcNDlih0=;
	b=VWQEPJJUvm0qDazNvRtqLG2i9nZrHNZtGu+MC4Vp6o4PuHvYvpyouwAbJQkhM7eSpZTcXh
	/jyZbai1BuLQ/CkhuAU4rzJMfemNXCXNldGL8WEDM0aJAPsQ0/1OPTObQrh4jQJ5vjbnkZ
	v7XicEqk26sQnhx3sAiiiY9AzQcTtR4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Use str_write_read() helper function
Message-ID: <3mulby6jk6o6ciwsa76dotzhs3deo62ark3bsh6ifwcs2foegt@ai4nr67jr3zc>
References: <20241019122526.42563-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241019122526.42563-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 19, 2024 at 02:25:27PM +0200, Thorsten Blum wrote:
> Remove hard-coded strings by using the helper function str_write_read().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Applied
