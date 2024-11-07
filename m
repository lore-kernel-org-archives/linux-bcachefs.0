Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078B218339
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Nov 2024 21:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731016053; cv=none; b=g//Vf3bKQG7ivpGKqt516F2OpiPnZCHQ69A65mNZZcZvh3VFsxIqF3lnyp1fifPt4+5mNpXoO8OaQAG9Dl98OBfO8wVVfEq9JeWbxt0eEYxYvA50NltOCL20iNAl8y6MjvGKaegEVdmTA5DvabqxXgjpRuTBg+ENFw22JAjJZ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731016053; c=relaxed/simple;
	bh=ZjMTrypOCLiv7Bi6Q4Bpin1/tA6zpIghK2T0gLJUjl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6FO4d7bvrZWZCxBX0scgJmPZhb1+S54Ax5clP+qde+zx6krIeU9KOzKR8lne+c/Ga9L4i038zKKcHagZUNJtCEINILyulkfkGw4xkskBIpMaQJfqszm17LyeYXkiUsJ4dzmp/rtP1qWl21o7gLKyvAc3X7fU+In6PHcCfwHGUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E9hf2LNW; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E9hf2LNW"
Date: Thu, 7 Nov 2024 16:47:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731016049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qarMuCg0HGS35PYy0J8BN981Pv54hF+gUjLbfxxnw+Y=;
	b=E9hf2LNWj1e7/ZPzTJO7Juokv0iohsMaRnbtFPR+Na/llK0NrPQVP4uOubz0/G9tW1l7nD
	28cBXHRXIWCkXH5Y1bb+fPpi1CEK0cR/p93Fnxmh5xBNx3skwA4T2qJfr25PHJkMkpNu/r
	2pZ3Es0rM5p8EaQcxfUUtg/XGRhRciQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: Correct the description of the '--bucket=size'
 options
Message-ID: <7bjapkeooupak7m5itzhxfthvxxdvdm3de35m7kbjwkhpbdgtw@ped6xt6h6u7i>
References: <20241016015026.1555670-1-youling.tang@linux.dev>
 <da24a338-72ba-4148-be01-359d740a5aba@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da24a338-72ba-4148-be01-359d740a5aba@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 31, 2024 at 04:05:44PM +0800, Youling Tang wrote:
> Hi, Kent
> 
> Give you a friendly ping. 🙂
> 
> BTW, is the following patch needed?
> [1] https://lore.kernel.org/linux-bcachefs/20240709011134.79954-1-youling.tang@linux.dev/
> [2] https://lore.kernel.org/linux-bcachefs/20240924025350.3948674-1-youling.tang@linux.dev/
> [3] https://lore.kernel.org/linux-bcachefs/20240927084042.1516361-1-youling.tang@linux.dev/
> [4] https://lore.kernel.org/linux-bcachefs/20241016014911.1555607-1-youling.tang@linux.dev/

Sorry, been behind :)

All those are in my bcachefs-testing branch now
