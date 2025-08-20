Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BE235334D;
	Wed, 20 Aug 2025 01:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755652731; cv=none; b=qizGQ4Wy8zySS9xC0bY0qhwJETrld+OJU7zJsiKX199iRnvfEaTlrmpVG0JqBUqvwpEWxy1RMPR6hhzHMnn+3Nbce6pJaRrbjBs9BN0cV5XfTz5d3NnHnv5GrBx0VTqGbq4ZbO6I2bggatd555bgIqwTaGQ2RI328E0uMDIF6ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755652731; c=relaxed/simple;
	bh=Zc8KTvnnxKKucPRYOFGi/LfFPLjaylS9ofv+IXSkWSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r+qAFaMN/2aa9GZ+3lfuqiLE3HkFVMvk8YzZQ2BvN/zA66ochP4h/HGU2nOG79IBIKdG7QM17cVq2hYrIFMKPhSNcZDjBez8Uaaxs9gbyCzvSAprZA3MW7qfXhbcs3/qNWOAc+v1fY+OdjkoTDZQqkpHQXgTpV+Pzjijybg4hhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SXxvhSF+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SXxvhSF+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=BiSimGacYECh9jzeLaODztaxsvnVtzIqcHjbY7zbm58=; b=SXxvhSF+IF2PyIMFltha02LLVP
	qAjDNq5bB3dA+uHo8m/4QiFzvkkcVsl5J6vsCyGmXtwRrBSXisM8Kd1HtY97RhWBD2qIgKOLCBc+1
	q7uIni4hKs+8L+gajwkGDJ+7HCzrpOzojE8VdQ6vZPyDpnv1NOvtZRdSn++CCTyO7SD0Tl1ER6bae
	VWEVdGX2fawYNP1AOs/NzWOSgjWL46gI7wSL5y04hyNqAr15hQ9fxBqLUzCkeNgtGZPG85u4ao+3m
	honXxKxwgNjExj6+FIKdhJZ5GfbDXzDI8YGUOR2bZbIlplqz0NhZplaU7USP6UPkvDRtAR5yrEaBN
	hQNUE2sw==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoXTT-0000000C4M6-2w7b;
	Wed, 20 Aug 2025 01:18:47 +0000
Message-ID: <33d4f923-250b-48f0-b5f5-664f09a2edf5@infradead.org>
Date: Tue, 19 Aug 2025 18:18:47 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: bcachefs: Add explicit title for idle work
 design doc
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux bcachefs <linux-bcachefs@vger.kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>
References: <20250820002218.11547-1-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250820002218.11547-1-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 8/19/25 5:22 PM, Bagas Sanjaya wrote:
> Commit 9e260e4590e044 ("docs: bcachefs: idle work scheduling design doc")
> adds design doc (desiderata) for idle work scheduling, but missed
> explicit title, causing its two section headings to be toctree entries
> instead.
> 
> Add the title.
> 
> Fixes: 9e260e4590e0 ("docs: bcachefs: idle work scheduling design doc")
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>  Documentation/filesystems/bcachefs/future/idle_work.rst | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
> index 59a332509dcd97..30f2844c3d9e5e 100644
> --- a/Documentation/filesystems/bcachefs/future/idle_work.rst
> +++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
> @@ -1,4 +1,5 @@
> -Idle/background work classes design doc:
> +Idle/background work classes desiderata
> +=======================================

I agree with the underline change and tested it. However, I don't care
for the change in the wording.

>  
>  Right now, our behaviour at idle isn't ideal, it was designed for servers that
>  would be under sustained load, to keep pending work at a "medium" level, to
> 
> base-commit: 37c52167b007d9d0bb8c5ed53dd6efc4969a1356

Tested-by: Randy Dunlap <rdunlap@infradead.org>


-- 
~Randy
