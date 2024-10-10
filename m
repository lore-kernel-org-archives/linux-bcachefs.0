Received: from relay-b03.edpnet.be (relay-b03.edpnet.be [212.71.1.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86FD19ABA3
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.71.1.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728586089; cv=none; b=X/uRYhEFI6rcpHjOTUPaOYzNdWxPezJvanh7be6YWs/YdvCHpTvHZ2s8/OlCPENnBWLAcrUFghMzsVoOvt7BLPy3Ob8wR5ksqD/p6S55ArRXj/HHN3QXMPg4HBd4KDvbF+TtYsmwqHci02bmWhVBSdGrLAHV5hEPeY8XTZN23vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728586089; c=relaxed/simple;
	bh=L2H/A5g+ca8SZB7UWz2ZJ0fj9FZcHcMtHWhEFLRMPnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=agCS+g67yID/J8NpnExMECbfX/QwgDrke8NNmaQh5DaxEBpPkJeVc/9uuaoR9DEj+li8cfOTR7W/Ltkids8+ROX95lcDVI/gPDimwSb53s5bXAKPZf05vVvmEp0g+R9YX/54rrbDCYUkzNygytVPvDLSLfMQi7eNnNgwBoIufoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kabelmail.de; spf=fail smtp.mailfrom=kabelmail.de; arc=none smtp.client-ip=212.71.1.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kabelmail.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kabelmail.de
X-ASG-Debug-ID: 1728585259-24639c1dac1642160001-qsCQDO
Received: from [192.168.177.53] (94.105.112.108.dyn.edpnet.net [94.105.112.108]) by relay-b03.edpnet.be with ESMTP id RpMAc61jCaSgro3y; Thu, 10 Oct 2024 20:34:19 +0200 (CEST)
X-Barracuda-Envelope-From: janpieter.sollie@kabelmail.de
X-Barracuda-Effective-Source-IP: 94.105.112.108.dyn.edpnet.net[94.105.112.108]
X-Barracuda-Apparent-Source-IP: 94.105.112.108
Message-ID: <5ce26939-a6d3-469b-8bc8-f622cd270315@kabelmail.de>
Date: Thu, 10 Oct 2024 20:33:12 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH resend v2] bcachefs: reject unknown mount options
To: David Disseldorp <ddiss@suse.de>, linux-bcachefs@vger.kernel.org
X-ASG-Orig-Subj: Re: [PATCH resend v2] bcachefs: reject unknown mount options
Cc: Martin Doucha <martin.doucha@suse.com>, Hongbo Li
 <lihongbo22@huawei.com>, Kent Overstreet <kent.overstreet@linux.dev>
References: <20240917013957.13353-1-ddiss@suse.de>
Content-Language: nl
From: Janpieter Sollie <janpieter.sollie@kabelmail.de>
Autocrypt: addr=janpieter.sollie@kabelmail.de; keydata=
 xsBNBFhRXM0BCADnifwYnfbhQtJso1eeT+fjEDJh8OY5rwfvAbOhHyy003MJ82svXPmM/hUS
 C6hZjkE4kR7k2O2r+Ev6abRSlM6s6rJ/ZftmwOA7E8vdSkrFDNqRYL7P18+Iq/jM/t/6lsZv
 O+YcjF/gGmzfOCZ5AByQyLGmh5ZI3vpqJarXskrfi1QiZFeCG4H5WpMInml6NzeTpwFMdJaM
 JCr3BwnCyR+zeev7ROEWyVRcsj8ufW8ZLOrML9Q5QVjH7tkwzoedOc5UMv80uTaA5YaC1GcZ
 57dAna6S1KWy5zx8VaHwXBwbXhDHWvZP318um2BxeTZbl21yXJrUMbYpaoLJzA5ZaoCFABEB
 AAHNMEphbnBpZXRlciBTb2xsaWUgPGphbnBpZXRlci5zb2xsaWVAa2FiZWxtYWlsLmRlPsLA
 pwQTAQgAUQIbIwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAUJD6DYHRYhBGBBYpsrUd7LDG6r
 UrFUjEUPH5JbBQJlAXcQEhhoa3A6Ly9wZ3AubWl0LmVkdQAKCRCxVIxFDx+SW3oXB/9A4g3v
 /Mq6uZlBDWBrQ98AFhlkRLwI2mDiNOlP4zJlejqt8S2GvCvhiQAtXV0BSl42sHo9Uxda8sZM
 d1eOU+oPexaK9iryCEYvOj+IK+n/rR8kyH5P7lzdpHIKYGtZ2y2NtpEuIA9A28MvliGjutJ2
 QIAdUaO1GdFVHXvHConuXvBfpmJsBhJeVfoTdzrTlloFTloCC+00a6Q6ndGnwzQQVgfgzRtq
 +x3O8smVnzsHb7Wu25+sbJl55GONAqyxuRmAF8IB4HAQ9gjgiCxTfjhCt9rhXQgPlT8EAuKT
 9MohNtqpXXZFpuQUYRMEqpM7mPfbm4L8fXiPv/szVM0ZIwVCzsBNBFhRXM0BCAD2fJkCQE6L
 UjUpVltzXjxeRTNQK/W3PC1i3EsjHFSJT04MY12zmXWI0ItNqnRaB2c/X/rtWTuYazSsgQTQ
 P/qZSts2890GD51y3BAw443rN0plVp4dX6JG/p3V0ha7rXwFjn4Hzgt4IDJSVuNa9nGEceId
 qTnvZO+F4ukgzV2YVAUWcuDowCBDfRm3yU0GU3rxOHfBTpYwljqFWbGqijsTjF1/Le4ULF+q
 HUQqwTDY1ijpxRCIeu46WoQEf5Dv0aTIwOJgPK8229uRDHlHhMPvXpqtBYKwQ/rOCz7EfITD
 lPsHhjnqR+mjeLy7tK/qIyaE7A8HTdoxYoYhAR+AqylRABEBAAHCwHwEGAEIACYCGwwWIQRg
 QWKbK1Heywxuq1KxVIxFDx+SWwUCXowzcAUJD6DYIwAKCRCxVIxFDx+SW1J3CADK79k3T1La
 jEHZGkxWPoAuixN8F6pf7hnofoR2KFkMbQk+9WYfiGsOcZwJjiUyQgiaSZcdz6QGkGPDjfLL
 iNDKvGGGAgRT99ruA4uyfAXjObbrMp8VGr0fI6eRF3nWuh5Rk4W2DY/wjaygA0FJ/vpw8XFs
 9NycYvk7yPcXW29N6/56TIc1I7SxmsEzwriGxvuRNZBzuNsEvdgzkF0kTL4nMhH/olPFW1+f
 2Y0kA3aAa1ZyjzHsgDUBSKyv35MJRxPLkLK4I/5DisNfjfygE/gvSh+Iss+ZqtZhYzR9oA6k
 mg7rIQaHeVNOBwFsmkHmXDmH5beCJsgB6hwxiQAUaOaO
In-Reply-To: <20240917013957.13353-1-ddiss@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: 94.105.112.108.dyn.edpnet.net[94.105.112.108]
X-Barracuda-Start-Time: 1728585259
X-Barracuda-URL: https://212.71.1.220:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at edpnet.be
X-Barracuda-Scan-Msg-Size: 1953
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=7.0 tests=MAILTO_TO_SPAM_ADDR
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.131632
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 MAILTO_TO_SPAM_ADDR    Includes a link to a likely spammer email

Op 17/09/2024 om 03:39 schreef David Disseldorp:
> This is effectively a revert of commit 03ef80b469d5 ("bcachefs: Ignore
> unknown mount options"), rebased atop commit 929d954330142 ("bcachefs:
> use new mount API").
>
> Contrary to the 03ef80b469d5 commit message, unknown mount options do
> result in failure on other filesystems such as xfs, btrfs, ext4, etc.
>
> Ignoring unknown options may result in unexpected behaviour: e.g. if
> an application requires future-workload-specific-mount-option to work
> and is run on a system without future-workload-specific-mount-option
> kernel support, then it may fail without indication of the missing
> kernel functionality.
>
> This reversion may cause failures for existing users reliant on the
> ignore-unknown behaviour, but it should be bearable given bcachefs is
> still flagged experimental.
>
> Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")
> Reported-by: Martin Doucha <martin.doucha@suse.com>
> Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1230065
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>   fs/bcachefs/opts.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index e10fc1da71b19..bc5c180878212 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -482,9 +482,8 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
>   		val = "0";
>   	}
>   
> -	/* Unknown options are ignored: */
>   	if (id < 0)
> -		return 0;
> +		goto bad_opt;
>   
>   	if (!(bch2_opt_table[id].flags & OPT_MOUNT))
>   		goto bad_opt;
Testing this patch caused my bcachefs mount command to fail:
the "user" and "nofail" attributes in /etc/fstab are not recognised.
I'd love the "nofail" attribute on a "experimental" filesystem. IMO it is even a soft requirement

Janpieter Sollie
