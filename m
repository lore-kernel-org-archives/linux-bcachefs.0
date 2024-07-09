Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E434084C
	for <linux-bcachefs@vger.kernel.org>; Tue,  9 Jul 2024 02:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720491104; cv=none; b=NeuhxIAYF8mKhGSYUumFxpv/65WrVeWI08mj1qhlGoBgfxj54Xb9GFcsC86dFPjebLtA22o2WJoWJqzrRddFaDImJ41izvHy8/iG8vI6Jibyvqr0uYs0+rIPXv2iuYtv8JtLXo6VJW+5k2lU1GH91BMJNFow+tRuGujfLBcXErQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720491104; c=relaxed/simple;
	bh=lOI/ee5qe03AFUKQUpqLcXd/DvpW5d4Oz7RRoR9bTKw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZGEr08UYOfo+bVQfhtLyfzAtwnFpe6v/BXBPv0xRQkv7FCvw4OkLXSubLYFXeU3p5HCdI7TmFlOYFPs2N6rXguc9b5j8Y76x1kiiIEBsX6rI3TaOaZs6dEBLYTNQEuNrEOVdbKiamzg4sWxkq11Lncqc/U6jaZAP2n2g3fmEgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=App89Qju; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="App89Qju"
X-Envelope-To: lihongbo22@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720491099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HjyNf7GxbR4lp5E+Hv52DxdeqK/OeMCXoQUH5A/KOQ=;
	b=App89Qju1287CgL+h0UMyqsy3BmS2uD36v0zqfcUmo/dJiUslc1GQF3P3yWkqOl9WMICL8
	Sf74ktxHMyL1vnNmfbNfe37NsoFseLSzNxs9zIloCvsBuPZA0ky3/Ccm7EPjLgIOaA6V5p
	mGzaQV3MNpZtLS0ZGPP5nEcTjSKqDTA=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: kent.overstreet@linux.dev
Message-ID: <c3471af6-0df7-44a9-8272-ab211f0f1b1b@linux.dev>
Date: Tue, 9 Jul 2024 10:11:17 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] bcachefs: Add support for FS_IOC_GETFSSYSFSPATH
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <20240709011134.79954-1-youling.tang@linux.dev>
 <20240709011134.79954-2-youling.tang@linux.dev>
 <8a1b37b5-450c-4f12-978e-25d691fbf21b@huawei.com>
Content-Language: en-US, en-AU
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <8a1b37b5-450c-4f12-978e-25d691fbf21b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 09/07/2024 10:04, Hongbo Li wrote:
>
>
> On 2024/7/9 9:11, Youling Tang wrote:
>> From: Kent Overstreet <kent.overstreet@linux.dev>
>>
>> [TEST]:
>> ```
>> $ cat ioctl_getsysfspath.c
>>   #include <stdio.h>
>>   #include <stdlib.h>
>>   #include <fcntl.h>
>>   #include <sys/ioctl.h>
>>   #include <linux/fs.h>
>>   #include <unistd.h>
>>
>>   int main(int argc, char *argv[]) {
>>       int fd;
>>       struct fs_sysfs_path sysfs_path = {};
>>
>>       if (argc != 2) {
>>           fprintf(stderr, "Usage: %s <path_to_file_or_directory>\n", 
>> argv[0]);
>>           exit(EXIT_FAILURE);
>>       }
>>
>>       fd = open(argv[1], O_RDONLY);
>>       if (fd == -1) {
>>           perror("open");
>>           exit(EXIT_FAILURE);
>>       }
>>
>>       if (ioctl(fd, FS_IOC_GETFSSYSFSPATH, &sysfs_path) == -1) {
>>           perror("ioctl FS_IOC_GETFSSYSFSPATH");
>>           close(fd);
>>           exit(EXIT_FAILURE);
>>       }
>>
>>       printf("FS_IOC_GETFSSYSFSPATH: %s\n", sysfs_path.name);
>>       close(fd);
>>       return 0;
>>   }
>>
>> $ gcc ioctl_getsysfspath.c
>> $ sudo bcachefs format /dev/sda
>> $ sudo mount.bcachefs /dev/sda /mnt
>> $ sudo ./a.out /mnt
>>    FS_IOC_GETFSSYSFSPATH: bcachefs/c380b4ab-fbb6-41d2-b805-7a89cae9cadb
>> ```
>>
>> Original patch link:
>> [1]: 
>> https://lore.kernel.org/all/20240207025624.1019754-8-kent.overstreet@linux.dev/
>>
>> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>> Signed-off-by: Youling Tang <youling.tang@linux.dev>
>> ---
>>   fs/bcachefs/fs.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
>> index 011ee5075a52..8699770398d1 100644
>> --- a/fs/bcachefs/fs.c
>> +++ b/fs/bcachefs/fs.c
>> @@ -1978,6 +1978,7 @@ static int bch2_fs_get_tree(struct fs_context *fc)
>>       sb->s_time_min        = div_s64(S64_MIN, 
>> c->sb.time_units_per_sec) + 1;
>>       sb->s_time_max        = div_s64(S64_MAX, 
>> c->sb.time_units_per_sec);
>>       super_set_uuid(sb, c->sb.user_uuid.b, sizeof(c->sb.user_uuid));
>> +    super_set_sysfs_name_uuid(sb);
>
> Reviewed-by: Hongbo Li <lihongbo22@huawei.com>
>
> It's quite strange that other commits have been merged, but the ones 
> for bcachefs have not been merged.
Because bcachefs was not upstream at the time, [1] described the following:
   Note, I dropped the bcachefs changes because they're not upstream yet.
   But once this is a stable branch you can just pull in vfs.uuid and rely
   on that.

[1]: 
https://lore.kernel.org/all/20240208-wecken-nutzen-3df1102a39b2@brauner/

Thanks,
Youling.
