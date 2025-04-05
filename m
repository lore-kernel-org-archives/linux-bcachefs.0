Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CD14C74
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Apr 2025 13:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743861389; cv=none; b=rjUlv4S+EpItJPwIpsdrragUAb+nUdTSKo2U857CHLwFFR2hbxErxGRcFav69KFihEIBe/QkAJoweILPajquhfHFttFuHs3Z39oTNmuvOCVZ4m6Gup1P9hbJdpuW0fn04rLzxTLaKFL5MAejHRp+9PXEqCZMu3BXZOMhJq/3N6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743861389; c=relaxed/simple;
	bh=sgZM81QTLPbxNJ34N4Otd6cllcNNjvL63DxZIxumDis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PO/SR2YOzjsZvHxnKlh03FNZOEEAyokyXiLUgq5Iv5cP2jm4zlaF5ZTReQweTlnxelOCJRsd0HW9DEG0aVbKZctnL/r7SlLqP1Kf/uaAB1RN1fJNVr4XRlN2FDlYfc7PMvWmUbVQ1pA6OSDsrGEm/pJRmvjwV10utHBy85SO3MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pUdab/BO; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pUdab/BO"
Date: Sat, 5 Apr 2025 09:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743861384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vDrzN2L7g329lp+mVpTXqY4dyPOkbcEc1bg0kNhDQEM=;
	b=pUdab/BO0j+CQeJAL0K88wIEGl+uDbU9BE8OglPNfrkATviOqqS/I1gYKr+pretessiR3q
	UDnfnyYoYOOY0FsPAQiHpcGgsujR0E2vTQxT0V8L9jBrUprusrg1M6sIj3mMM8LeUc+J22
	CIS2qCwSC3WpYz0IRgx0JuT4vrMHfVs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, 
	Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH resend] bcachefs-tools: add missing "fs top" command to
 manual
Message-ID: <4ptz5m7os52pe3zf6qrkxnjuuawgte37ue2kpyhxph23czupzu@5wb6m23c7k7i>
References: <20250405123616.12182-2-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250405123616.12182-2-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Apr 05, 2025 at 08:36:17PM +0800, Integral wrote:
> This patch adds the missing "fs top" command to manual.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Maybe we could add a lint for this? Applying

> ---
>  bcachefs.8 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/bcachefs.8 b/bcachefs.8
> index 30cdd392..37cf0a8f 100644
> --- a/bcachefs.8
> +++ b/bcachefs.8
> @@ -37,6 +37,8 @@ Check an existing filesystem for errors.
>  .Bl -tag -width 18n -compact
>  .It Ic fs usage
>  Show disk usage
> +.It Ic fs top
> +Show runtime performance information
>  .El
>  .Ss Commands for managing devices within a running filesystem
>  .Bl -tag -width 22n -compact
> -- 
> 2.49.0
> 
